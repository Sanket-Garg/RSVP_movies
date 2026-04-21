# RSVP Movies SQL Analysis

## Business Problem
RSVP Movies (Indian production company) is planning a global release in 2022.
This analysis uses 3 years of IMDB movie data to provide data-driven 
recommendations on genre, director, actor, and production partner selection.

## Dataset
- 6 tables: movie, genre, ratings, names, role_mapping, director_mapping
- ~7,000+ movies across 2017-2019

## Key Business Insights Found
1. Drama genre had highest movie count — recommended primary genre
2. James Mangold identified as top director for target genre
3. Marvel Studios ranked #1 production house by total votes
4. Star Cinema and Twentieth Century Fox recommended as multilingual partners

## SQL Concepts Used
- Window Functions (RANK, DENSE_RANK, ROW_NUMBER, LEAD)
- CTEs for complex multi-step queries
- Weighted averages for fair rating comparisons
- Date arithmetic for inter-movie duration analysis

## Files
- rsvp_analysis.sql — All queries with comments
- insights_summary.pdf — Business recommendations

## Tools
MySQL
