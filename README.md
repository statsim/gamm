# Generalized Additive Mixed Models using Shiny and mgcv

### Open on shinyapps
[https://statsim.shinyapps.io/gamm/](https://statsim.shinyapps.io/gamm/)
We are currently on a free tier. The app can be offline if there's no hours left.


### Run gamm with R from remote repository
`R -e "shiny::runGitHub('gamm', 'statsim')"` (needs R and shiny installed)

If everything is ok, you'll see something like this:

```
Downloading https://github.com/statsim/gamm/archive/master.tar.gz
Loading required package: shiny
Loading required package: nlme
This is mgcv 1.8-28. For overview type 'help("mgcv-package")'.

Listening on http://127.0.0.1:5352
```

Then just open the link in the browser

### Run locally
`R -e "shiny::runApp('./gamm')"`


