"""
Lab 3: Hospitality Demand
Streamlit Dashboard

Run with: make run
"""

import streamlit as st

st.set_page_config(
    page_title="Lab 3: Hospitality Demand",
    page_icon="🏨",
    layout="wide",
)

# Header
st.title("🏨 Hospitality Demand Analysis")
st.markdown("**Lab 3** | Analyzing Hotel Booking Patterns and Cancellation Drivers")
st.markdown("---")

# Success message
st.success("✅ **Streamlit is working!** You're ready to start Lab 3.")

# Lab Overview
st.header("📋 What You'll Build")

col1, col2 = st.columns(2)

with col1:
    st.markdown("""
    **Datasets You'll Use:**
    - 🛎️ Hotel Booking Demand (119K bookings)
    - 📅 Arrival dates and lead times
    - 👥 Guest information (adults, children, country)
    - ❌ Cancellation status and history
    """)

with col2:
    st.markdown("""
    **Key Questions to Answer:**
    - What factors predict booking cancellations?
    - How does lead time affect cancellation rate?
    - Which seasons have highest demand?
    """)

st.markdown("---")

# Quick Stats (placeholder)
st.header("📊 Dashboard Preview")
st.info("👇 These metrics will show real data after you run the pipeline (`make pipeline`)")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Total Bookings", "119,390")
col2.metric("Cancellation Rate", "37%", delta="-5% vs target", delta_color="inverse")
col3.metric("Avg Lead Time", "104 days")
col4.metric("Countries", "178", help="Guest countries of origin")

st.markdown("---")

# Sample Chart Placeholder
st.header("📈 Cancellation by Lead Time")

st.info("📊 Chart will appear here after running the pipeline")

# Fake data for preview
import random
lead_time_buckets = ["0-7 days", "8-30 days", "31-90 days", "91-180 days", "180+ days"]
cancel_rates = [15, 25, 38, 45, 52]

# Simple bar representation
for bucket, rate in zip(lead_time_buckets, cancel_rates):
    st.write(f"**{bucket}**")
    st.progress(rate / 100)
    st.caption(f"{rate}% cancellation rate")

st.markdown("---")

# Next Steps
st.header("🚀 Next Steps")

st.markdown("""
1. **Download the datasets**
   ```bash
   make download
   ```

2. **Read Exercise 1** in `exercises/01_booking_pattern_analysis.md`

3. **Use Vibe Coding** - Copy prompts into your AI tool

4. **Run the pipeline**
   ```bash
   make pipeline
   ```
""")

st.markdown("---")
st.caption("SRX Data Science Labs | Lab 3 of 5 | Vibe Coding with AI")
