import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# Load processed datasets
tele = pd.read_csv("../data/processed/lfsa_ehomp_2015_2024_clean.csv")
sat1 = pd.read_csv("../data/processed/lfso_21jsat01_2015_2024_clean.csv")
sat4 = pd.read_csv("../data/processed/lfso_21jsat04_2021_clean.csv")

# Merge for 2021 analysis
tele2021 = tele[tele["time"]==2021]
dfm = (
    tele2021.merge(sat1, on=["geo","time"])
            .merge(sat4, on=["geo","time"])
            .rename(columns={
                "telework_any":"telework_2021",
                "share_high":"share_high_jsat01",
                "share_in_group":"share_high_jsat04"
            })
)

st.title("Telework and Job Satisfaction in Europe (EU-LFS)")

# --- Section 1: Time series explorer ---
st.header("Telework trends (2015–2024)")
country = st.selectbox("Choose a country:", sorted(tele["geo"].unique()))
fig, ax = plt.subplots()
subset = tele[tele["geo"]==country]
ax.plot(subset["time"], subset["telework_any"], marker="o")
ax.set_title(f"Telework in {country}")
ax.set_xlabel("Year")
ax.set_ylabel("% employees teleworking")
st.pyplot(fig)

# --- Section 2: Scatterplots ---
st.header("Telework vs Job Satisfaction (2021)")

choice = st.radio("Choose satisfaction measure:", 
                  ["Baseline (jsat01)", "WFH & Flexibility (jsat04)"])

yvar = "share_high_jsat01" if "Baseline" in choice else "share_high_jsat04"

fig, ax = plt.subplots()
ax.scatter(dfm["telework_2021"], dfm[yvar])
for _, row in dfm.iterrows():
    ax.text(row["telework_2021"]+0.3, row[yvar], row["geo"], fontsize=7)
ax.set_xlabel("Telework (% of employees, 2021)")
ax.set_ylabel("Share 'high satisfaction' (2021)")
ax.set_title(f"Telework vs Job Satisfaction — {choice}")
st.pyplot(fig)

# --- Section 3: Correlation ---
st.header("Correlation summary")
corr1 = dfm["telework_2021"].corr(dfm["share_high_jsat01"])
corr4 = dfm["telework_2021"].corr(dfm["share_high_jsat04"])
st.write(f"- Correlation with baseline (jsat01): {corr1:.2f}")
st.write(f"- Correlation with WFH & Flexibility (jsat04): {corr4:.2f}")
