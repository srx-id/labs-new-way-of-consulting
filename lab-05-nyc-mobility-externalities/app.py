"""
Lab 5: NYC Mobility Externalities
Streamlit Dashboard

Run with: make run
"""

import streamlit as st

st.set_page_config(
    page_title="Lab 5: NYC Mobility Externalities",
    page_icon="🚕",
    layout="wide",
)

# Header
st.title("🚕 NYC Mobility Externalities")
st.markdown("**Lab 5** | Correlating Taxi Volume with 311 Complaints (High Volume Data)")
st.markdown("---")

# Success message
st.success("✅ **Streamlit is working!** You're ready to start Lab 5.")

# Special Note
st.warning("""
⚠️ **High Volume Lab**: This lab teaches you to handle **100+ million rows** of data!

You'll learn chunking strategies, memory management, and efficient aggregation techniques.
""")

# Lab Overview
st.header("📋 What You'll Build")

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    **Datasets You'll Use:**
    - 🚕 NYC Taxi Trip Data (100M+ trips/year)
    - 📞 311 Service Requests (23M complaints)
    - 🗺️ NYC Taxi Zone Lookup (265 zones)
    """)

with col2:
    st.markdown("""
    **Key Questions to Answer:**
    - Do areas with more taxis have more noise complaints?
    - Is there an "externality" of urban mobility?
    - Which boroughs show strongest correlation?
    """)

st.markdown("---")

# Quick Stats (placeholder)
st.header("📊 Dashboard Preview")
st.info("👇 These metrics will show real data after you run the pipeline (`make pipeline`)")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Taxi Trips", "100M+", help="Per year")
col2.metric("311 Complaints", "23M", help="Nuisance-related")
col3.metric("Boroughs", "5")
col4.metric("Correlation", "r = 0.67", help="Taxi volume vs complaints")

st.markdown("---")

# The Research Question
st.header("🔬 The Research Question")

st.markdown("""
> **"Do areas with more taxi activity experience more noise and traffic-related complaints?"**

This is an important **urban planning** question:
- If **yes**: Taxi congestion has measurable quality-of-life costs
- **Policy implications**: Congestion pricing, traffic management, ride-share regulations
""")

st.markdown("---")

# High Volume Strategy
st.header("💾 Handling High Volume Data")

st.markdown("""
**The Challenge:** 100M+ rows won't fit in memory!

**Your Strategy (Chunking):**
```
┌─────────────────────────────────────────────────┐
│  Raw Data: 100M rows (too big!)                 │
└─────────────────────────────────────────────────┘
                    ↓ Process in chunks
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│ Chunk 1  │ │ Chunk 2  │ │ Chunk 3  │ │  ....    │
│  1M rows │ │  1M rows │ │  1M rows │ │          │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
     ↓             ↓            ↓            ↓
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│ Agg: 60  │ │ Agg: 60  │ │ Agg: 60  │ │  ....    │
│   rows   │ │   rows   │ │   rows   │ │          │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
                    ↓ Combine
┌─────────────────────────────────────────────────┐
│  Final: 60 rows (borough × month)               │
└─────────────────────────────────────────────────┘
```
""")

st.markdown("---")

# Next Steps
st.header("🚀 Next Steps")

st.markdown("""
1. **Download the datasets** (this may take a while - large files!)
   ```bash
   make download
   ```

2. **Read Exercise 1** in `exercises/01_volume_handling.md`

3. **Use Vibe Coding** - Copy prompts into your AI tool

4. **Run the pipeline** (uses chunking strategy)
   ```bash
   make pipeline
   ```
""")

st.markdown("---")
st.caption("SRX Data Science Labs | Lab 5 of 5 | Vibe Coding with AI")
