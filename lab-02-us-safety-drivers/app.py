"""
Lab 2: US Safety Drivers
Streamlit Dashboard

Run with: make run
"""

import streamlit as st

st.set_page_config(
    page_title="Lab 2: US Safety Drivers",
    page_icon="🚗",
    layout="wide",
)

# Header
st.title("🚗 US Safety Drivers Analysis")
st.markdown("**Lab 2** | Analyzing Accident Patterns with Weather and Geographic Data")
st.markdown("---")

# Success message
st.success("✅ **Streamlit is working!** You're ready to start Lab 2.")

# Lab Overview
st.header("📋 What You'll Build")

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    **Datasets You'll Use:**
    - 🚨 US Accidents (2.8M+ records)
    - 🌧️ Weather conditions at accident time
    - 📍 Geographic data (state, county, city)
    - ⏰ Temporal patterns (time, day, month)
    """)

with col2:
    st.markdown("""
    **Key Questions to Answer:**
    - Which weather conditions cause the most severe accidents?
    - What time of day has the highest accident rates?
    - Which states have the worst safety records?
    """)

st.markdown("---")

# Quick Stats (placeholder)
st.header("📊 Dashboard Preview")
st.info("👇 These metrics will show real data after you run the pipeline (`make pipeline`)")

col1, col2, col3, col4 = st.columns(4)
col1.metric("States", "49", help="Continental US states")
col2.metric("Accidents", "2.8M+", delta="2016-2023")
col3.metric("Severity Levels", "4", help="1 (minor) to 4 (severe)")
col4.metric("Weather Types", "12", help="Rain, snow, fog, etc.")

st.markdown("---")

# Sample Insight
st.header("💡 Sample Insight")

st.warning("""
**Preview of what you'll discover:**

> "Accidents during **heavy rain** are **2.3x more likely** to be severity 4 (most severe)
> compared to clear weather conditions. States with highest rain-related severity:
> Florida, Texas, California."

*This is example text - your analysis will reveal the actual patterns!*
""")

st.markdown("---")

# Next Steps
st.header("🚀 Next Steps")

st.markdown("""
1. **Download the datasets**
   ```bash
   make download
   ```

2. **Read Exercise 1** in `exercises/01_accident_pattern_analysis.md`

3. **Use Vibe Coding** - Copy prompts into your AI tool

4. **Run the pipeline**
   ```bash
   make pipeline
   ```
""")

st.markdown("---")
st.caption("SRX Data Science Labs | Lab 2 of 5 | Vibe Coding with AI")
