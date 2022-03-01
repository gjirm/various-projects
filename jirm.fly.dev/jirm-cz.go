package main

import (
	"embed"
	"io/fs"
	"log"
	"net/http"
	"net/url"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

//go:embed jirm.cz
var jirmCzContent embed.FS

func jirmCZ(mux *http.ServeMux) {
	handleFuncWithCounter(mux, "www.jirm.cz/", func(rw http.ResponseWriter, r *http.Request) {
		u := &url.URL{
			Scheme: "https", Host: "jirm.cz",
			Path: r.URL.Path, RawQuery: r.URL.RawQuery,
		}
		http.Redirect(rw, r, u.String(), http.StatusMovedPermanently)
	})

	// content to main site
	content, err := fs.Sub(jirmCzContent, "jirm.cz")
	if err != nil {
		log.Fatal(err)
	}

	// main site
	handleWithCounter(mux, "jirm.cz/", http.FileServer(http.FS(content)))

	// age public key
	handleFuncWithCounter(mux, "jirm.cz/age",
		func(rw http.ResponseWriter, _ *http.Request) {
			rw.Header().Set("Content-Type", "text/plain")
			rw.Write([]byte("# My age public key (https://age-encryption.org/)\n"))
			rw.Write([]byte("# Key ID is age-jirm-key-20220215\n"))
			rw.Write([]byte("# age -e -a -R <(curl -fs https://jirm.cz/age)\n"))
			rw.Write([]byte("age15xxxk0lz599yzhsf2qyvzgr69lm8ewtzws479qp89c9wp2gflugq2d92r6\n"))
		})

	// minisign public key
	handleFuncWithCounter(mux, "jirm.cz/minisign",
		func(rw http.ResponseWriter, _ *http.Request) {
			rw.Header().Set("Content-Type", "text/plain")
			rw.Write([]byte("untrusted comment: My minisign public key (https://jedisct1.github.io/minisign/). Verify: minisign -P $(curl -fs https://jirm.cz/minisign | tail -1) -Vm <file>\n"))
			rw.Write([]byte("RWRN2/G3Qiz5ddELm0jk7hLVuCEzodFiDKZBQT3eJ2u/LsbNgNo5guh8\n"))
		})

	// git clone redirects
	handleFuncWithCounter(mux, "jirm.cz/dotfiles/info/refs",
		func(rw http.ResponseWriter, r *http.Request) {
			url := "https://github.com/gjirm/dotfiles.git/info/refs?" + r.URL.RawQuery
			http.Redirect(rw, r, url, http.StatusFound)
		})

	handleFuncWithCounter(mux, "jirm.cz/gwc-server/info/refs",
		func(rw http.ResponseWriter, r *http.Request) {
			url := "https://github.com/gjirm/gwc-server.git/info/refs?" + r.URL.RawQuery
			http.Redirect(rw, r, url, http.StatusFound)
		})

	handleFuncWithCounter(mux, "jirm.cz/traefik-basic-auth-manager/info/refs",
		func(rw http.ResponseWriter, r *http.Request) {
			url := "https://github.com/gjirm/traefik-basic-auth-manager.git/info/refs?" + r.URL.RawQuery
			http.Redirect(rw, r, url, http.StatusFound)
		})

	// Miscellaneous redirects
	for path, url := range map[string]string{
		"/quickinstall": "https://github.com/gjirm/various-projects/blob/main/quick_install.sh",
		"/qi":           "https://raw.githubusercontent.com/gjirm/various-projects/main/quick_install.sh",
		"/pgp":          "https://keybase.io/jirm/pgp_keys.asc",
		"/ssh":          "https://github.com/gjirm.keys",
	} {
		path, url := path, url
		mux.HandleFunc("jirm.cz"+path, func(rw http.ResponseWriter, r *http.Request) {
			httpReqs.WithLabelValues("[redirect]").Inc()
			redirectReqs.WithLabelValues(path).Inc()
			http.Redirect(rw, r, url, http.StatusFound)
		})
	}
}

var redirectReqs = promauto.NewCounterVec(prometheus.CounterOpts{
	Name: "redirect_requests_total",
	Help: "Redirect requests processed, partitioned by path.",
}, []string{"path"})
