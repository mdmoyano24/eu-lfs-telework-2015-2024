![Python](https://img.shields.io/badge/Python-3.10-blue)
![Stata](https://img.shields.io/badge/Stata-17-lightgrey)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

# eu-lfs-telework-2015-2024
# Telework and Job Satisfaction in Europe (EU-LFS 2015–2024)

This project explores the relationship between the rise of telework in Europe and self-reported job satisfaction, using publicly available Eurostat Labour Force Survey (EU-LFS) datasets.


## Repository structure

- `data/raw/` – datasets downloaded from Eurostat (CSV/TSV format)  
- `data/processed/` – cleaned datasets ready for analysis (CSV + Stata .dta)  
- `notebooks/` – Jupyter notebooks (`01_download.ipynb`, `02_cleaning.ipynb`, `03_analysis.ipynb`)  
- `src/stata/` – Stata `.do` scripts reproducing the same workflow  
- `paper/figs/` – generated figures used in this README  

## Data sources

- **Telework prevalence (2015–2024):**  
  `lfsa_ehomp` — Share of employees working *usually* or *sometimes* from home.  
  Annual time series available for EU countries and aggregates.

- **Job satisfaction (2021 only):**  
  - `lfso_21jsat01`: Baseline job satisfaction (ad-hoc module).  
  - `lfso_21jsat04`: Job satisfaction by telework and working-time flexibility (ad-hoc module).  
  These modules were only collected in **2021** and are not available as a time series.

## How to reproduce
- **Python**:  
  Open `notebooks/01_download.ipynb` and run sequentially to fetch and clean Eurostat data.  
  Final analysis is in `03_analysis.ipynb`.

- **Stata**:  
  From `src/stata/`, run:
  
  ```
  do 00_setup.do
  do 10_ehomp_clean.do
  do 20_jsat01_clean.do
  do 21_jsat04_clean.do
  do 30_merge_plots_2021.do
  
  ```
Figures will be exported to `paper/figs/`.
  
## Key findings

- **Telework trend:**  
  - Stable at ~12–13% from 2015–2019.  
  - Sharp increase in 2020 due to the COVID-19 pandemic (above 20%).  
  - Levels remained elevated in 2021–2024 compared to the pre-pandemic period.  

- **Job satisfaction (2021):**  
  - No clear correlation between the share of employees teleworking and the proportion reporting "high job satisfaction".  
  - Results hold for both baseline satisfaction (`jsat01`) and satisfaction by telework/flexibility (`jsat04`).  

- **Implication:**  
  The rapid expansion of telework has not automatically translated into higher job satisfaction across Europe.

## Visuals

### Telework in the EU27 (2015–2024)
![Telework trend](figures/eu27_telework_2015_2024.png)

### Telework vs Job Satisfaction (2021)
![Telework vs satisfaction](figures/telework_vs_satisfaction_2021.png)

### Telework vs Job Satisfaction & Flexibility (2021)
![Telework vs satisfaction & flexibility](figures/telework_vs_satisfaction_flex_2021.png)

## Limitations

- Job satisfaction data are available only for 2021 (ad-hoc module).  
- More detailed analyses would require access to the restricted EU-LFS microdata.  

## Technologies

- **Python** (pandas, matplotlib) for data processing and visualisation.  
- **Eurostat API** for dataset download.  
- Jupyter notebooks for transparent analysis workflow.

## Interactive app 

An interactive [Streamlit](https://streamlit.io) app is included for exploring the data:

- Telework trends (2015–2024) by country
- Scatterplots (2021) telework vs job satisfaction
- Correlation summary

Run locally:

```bash
pip install -r requirements.txt
streamlit run app.py

```

## Citation

Data source: Eurostat, EU Labour Force Survey (EU-LFS), datasets:
- lfsa_ehomp (Telework prevalence)
- lfso_21jsat01 (Job satisfaction baseline, 2021)
- lfso_21jsat04 (Job satisfaction × WFH × flexibility, 2021)

## License

This project is released under the MIT License.  
Eurostat EU-LFS data are © European Union, re-used according to the Eurostat [reuse policy](https://ec.europa.eu/info/legal-notice_en)


## Next Steps

- Extend to other well-being indicators (e.g. EU-SILC, Eurofound surveys).  
- Explore differences by occupation, sector, or education level if microdata access is granted.  
- Compare EU trends with other OECD countries

