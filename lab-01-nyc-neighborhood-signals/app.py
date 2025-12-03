"""
Lab 1: NYC Neighborhood Signal Extraction
Streamlit Dashboard

Run with: make run
"""

import streamlit as st

st.set_page_config(
    page_title="Lab 1: NYC Neighborhood Signals",
    page_icon="🏙️",
    layout="wide",
)

# Header
st.title("🏙️ NYC Neighborhood Signal Extraction")
st.markdown("**Lab 1** | Correlating Airbnb with 311, Crime, and Weather Data")
st.markdown("---")

# Success message
st.success("✅ **Streamlit is working!** You're ready to start Lab 1.")

# Lab Overview
st.header("📋 What You'll Build")

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    **Datasets You'll Use:**
    - 🏠 NYC Airbnb listings (49K rows)
    - 📞 311 Service Requests (23M rows)
    - 🚔 NYPD Crime Data (5M rows)
    - 🌤️ NYC Weather Data (56K rows)
    """)

with col2:
    st.markdown("""
    **Key Questions to Answer:**
    - Do neighborhoods with more complaints have lower Airbnb prices?
    - Is there a "safety premium" in low-crime areas?
    - How does weather affect booking patterns?
    """)

st.markdown("---")

# Quick Stats (placeholder)
st.header("📊 Dashboard Preview")
st.info("👇 These metrics will show real data after you run the pipeline (`make pipeline`)")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Boroughs", "5", help="Manhattan, Brooklyn, Queens, Bronx, Staten Island")
col2.metric("Avg Price", "$152", delta="+$12 vs last month")
col3.metric("Correlation", "r = -0.42", help="Crime vs Price correlation")
col4.metric("Data Points", "60", help="5 boroughs × 12 months")

st.markdown("---")

# Next Steps
st.header("🚀 Next Steps")

st.markdown("""
1. **Download the datasets**
   ```bash
   make download
   ```

2. **Read Exercise 1** in `exercises/01_data_exploration.md`

3. **Use Vibe Coding** - Copy prompts into your AI tool (Claude Code, Cursor, etc.)

4. **Run the pipeline** as you complete exercises
   ```bash
   make pipeline
   ```

5. **See your results** here in this dashboard!
""")

st.markdown("---")

# Footer
st.caption("SRX Data Science Labs | Lab 1 of 5 | Vibe Coding with AI")
