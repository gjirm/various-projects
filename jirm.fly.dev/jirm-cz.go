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

	content, err := fs.Sub(jirmCzContent, "jirm.cz")
	if err != nil {
		log.Fatal(err)
	}
	// TODO: metrics counter for which files are loaded.
	handleWithCounter(mux, "jirm.cz/", http.FileServer(http.FS(content)))

	handleFuncWithCounter(mux, "jirm.cz/age",
		func(rw http.ResponseWriter, _ *http.Request) {
			rw.Header().Set("Content-Type", "text/plain")
			rw.Write([]byte("# My age public key (https://age-encryption.org/)\n"))
			rw.Write([]byte("# Key ID is age-jirm-key-20220215\n"))
			rw.Write([]byte("# age -e -a -R <(curl -fs https://jirm.cz/age)\n"))
			rw.Write([]byte("age15xxxk0lz599yzhsf2qyvzgr69lm8ewtzws479qp89c9wp2gflugq2d92r6\n"))
		})

	handleFuncWithCounter(mux, "jirm.cz/minisign",
		func(rw http.ResponseWriter, _ *http.Request) {
			rw.Header().Set("Content-Type", "text/plain")
			rw.Write([]byte("untrusted comment: My minisign public key (https://jedisct1.github.io/minisign/). Verify: minisign -Vm <file> -P <(curl -fs https://jirm.cz/minisign)\n"))
			rw.Write([]byte("RWSp5bkunYko2ofULwBAD89mWHQtaj/99OK9SJgJMUk48m2PQTV8TjcZ\n"))
		})

	// Miscellaneous redirects
	for path, url := range map[string]string{
		"/quickinstall":               "https://github.com/gjirm/various-projects/blob/main/quick_install.sh",
		"/qi":                         "https://raw.githubusercontent.com/gjirm/various-projects/main/quick_install.sh",
		"/pgp":                        "https://keybase.io/jirm/pgp_keys.asc",
		"/dotfiles":                   "https://github.com/gjirm/dotfiles",
		"/traefik-basic-auth-manager": "https://github.com/gjirm/gwc-server",
		"/gwc-server":                 "https://github.com/gjirm/gwc-server",
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
