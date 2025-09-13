* Basic Stata setup (silent, reproducible)
version 17
clear all
set more off
set linesize 200
capture mkdir "../../data/processed"
capture mkdir "../../paper/figs"

* (Optional) Install SDMX client if you want to download directly from Eurostat
* ssc install sdmxuse, replace