"""
Lab 4: Streaming Catalog Reconciliation
Streamlit Dashboard

Run with: make run
"""

import streamlit as st

st.set_page_config(
    page_title="Lab 4: Streaming Catalog",
    page_icon="🎬",
    layout="wide",
)

# Header
st.title("🎬 Streaming Catalog Reconciliation")
st.markdown("**Lab 4** | Fuzzy Matching and Entity Resolution Across Platforms")
st.markdown("---")

# Success message
st.success("✅ **Streamlit is working!** You're ready to start Lab 4.")

# Lab Overview
st.header("📋 What You'll Build")

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    **Datasets You'll Use:**
    - 🔴 Netflix catalog (8,800+ titles)
    - 🔵 Amazon Prime catalog (9,600+ titles)
    - 🟣 Disney+ catalog (1,400+ titles)
    """)

with col2:
    st.markdown("""
    **Key Questions to Answer:**
    - How many titles appear on multiple platforms?
    - Can we match titles with slightly different names?
    - What's the overlap between streaming services?
    """)

st.markdown("---")

# Quick Stats (placeholder)
st.header("📊 Dashboard Preview")
st.info("👇 These metrics will show real data after you run the pipeline (`make pipeline`)")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Netflix", "8,807 titles")
col2.metric("Amazon Prime", "9,668 titles")
col3.metric("Disney+", "1,450 titles")
col4.metric("Potential Matches", "~2,500", help="Estimated cross-platform overlap")

st.markdown("---")

# Fuzzy Matching Example
st.header("🔍 Fuzzy Matching Example")

st.markdown("**The Challenge:** Same movie, different names across platforms")

col1, col2, col3 = st.columns(3)

with col1:
    st.markdown("**Netflix**")
    st.code("The Avengers (2012)")

with col2:
    st.markdown("**Amazon Prime**")
    st.code("Marvel's The Avengers")

with col3:
    st.markdown("**Match Score**")
    st.code("87% similarity")

st.info("""
**Fuzzy matching** finds these are the same movie even though the titles differ!

You'll learn techniques like:
- Levenshtein distance
- Token-based matching
- Phonetic matching (Soundex, Metaphone)
""")

st.markdown("---")

# Platform Overlap Visualization
st.header("📊 Platform Overlap (Preview)")

st.markdown("""
```
        Netflix ○───────────○ Amazon Prime
                 ╲   ~800  ╱
                  ╲ titles╱
                   ╲    ╱
                    ╲  ╱
                     ○
                  Disney+
                  ~200 on all 3
```
*Actual numbers will come from your analysis!*
""")

st.markdown("---")

# Next Steps
st.header("🚀 Next Steps")

st.markdown("""
1. **Download the datasets**
   ```bash
   make download
   ```

2. **Read Exercise 1** in `exercises/01_catalog_profiling.md`

3. **Use Vibe Coding** - Copy prompts into your AI tool

4. **Run the pipeline**
   ```bash
   make pipeline
   ```
""")

st.markdown("---")
st.caption("SRX Data Science Labs | Lab 4 of 5 | Vibe Coding with AI")
