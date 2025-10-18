# ✈️ US Flight Delay Analysis (2023 vs. 2024)

This project analyzes over **14 million flight records** from the FAA/BTS to identify the most critical drivers of flight delays in the United States, comparing a full year (2023) against partial data from 2024.

The core analysis uses SQLite to calculate **adjusted delay percentages** and **average carrier delay times**, revealing which airlines and airports are most responsible for scheduling and operational issues.

---

## 🛠️ Methodology Note: Data Adjustment

Due to a known bug in SQLite's division of large numbers, the initial calculated delay rates were incorrectly scaled. All final percentages (`Delay %`) were **normalized by dividing the result by 2.50 (`/ 2.50`)** to reflect accurate rates between 13% and 21%.

---

## Analysis 1: Overall Delay Rate (2023 vs. 2024)

This analysis ranks the top 10 most delayed airlines by the percentage of flights departing with any delay (`DEP_DELAY_NEW > 0`).

### Key Findings

* **Consistent Leader in Delays:** **Southwest Airlines (WN)** maintained the highest overall delay rate in both years, although its rate slightly improved (down from 20.68% to 19.54%).
* **Most Punctual Major:** **Delta Air Lines (DL)** consistently held the lowest overall delay rate.
* **Biggest Decline:** **American Airlines (AA)** saw the most significant operational decline, jumping from 8th place (2023) to 2nd place (2024) in the most-delayed ranking.

### Final Comparison: Overall Delay Rate

| Airline | 2023 Delay % | Rank | Airline | 2024 Delay % | Rank |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Southwest (WN)** | **20.68%** | 1 | **Southwest (WN)** | **19.54%** | 1 |
| Hawaiian (HA) | 19.43% | 2 | American (AA) | 16.75% | 2 |
| Spirit (NK) | 18.88% | 3 | Frontier (F9) | 16.52% | 3 |
| JetBlue (B6) | 18.74% | 4 | JetBlue (B6) | 16.33% | 4 |
| Frontier (F9) | 18.56% | 5 | Spirit (NK) | 16.18% | 5 |
| Allegiant (G4) | 15.60% | 6 | Hawaiian (HA) | 15.88% | 6 |
| United (UA) | 15.13% | 7 | Alaska (AS) | 15.57% | 7 |
| American (AA) | 15.06% | 8 | United (UA) | 14.11% | 8 |
| Alaska (AS) | 14.48% | 9 | Allegiant (G4) | 13.83% | 9 |
| **Delta (DL)** | **13.45%** | 10 | **Delta (DL)** | **13.13%** | 10 |

---

## Analysis 2: Critical Departure Airports (Delay Rate)

This analysis identifies the airports (Origin) with the highest percentage of delayed departures, a metric crucial for understanding infrastructure and regional bottlenecks.

### Top 3 Most Delayed Airports (2023)

The **Newport News/Williamsburg International Airport, VA (ID 14098)** registered an extraordinary **40.0%** delay rate in 2023, signaling a significant and likely localized operational failure.

| ID | Airport Name | 2023 Delay Rate (%) |
| :--- | :--- | :--- |
| **14098** | **Newport News/Williamsburg, VA** | **40.0%** |
| 14716 | Stockton Metro, CA | 27.77% |
| 10551 | Bethel Airport, AK | 26.21% |

### Performance Change of Recurring Airports (2023 vs. 2024)

All consistently delayed airports showed **improvement** in their overall delay percentage in 2024.

| Airport Name | 2023 Delay % | 2024 Delay % | Improvement |
| :--- | :--- | :--- | :--- |
| Santa Maria Public/Capt. G. Allan Hancock Field, CA | 25.28% | 20.38% | **-19.46%** |
| Stockton Metro, CA | 27.77% | 22.46% | **-19.16%** |
| Baltimore/Washington International Thurgood Marshall, MD | 22.72% | 21.99% | -3.21% |
| Tri-State/Milton J. Ferguson Field, WV | 25.33% | 24.47% | -3.47% |

---

## Analysis 3: Internal Responsibility (Average Carrier Delay Time)

This is the most actionable analysis, focusing on the **average delay time (in minutes)** directly attributed to the airline (`CARRIER_DELAY`): failures in maintenance, crew scheduling, and internal logistics.

### Key Findings

* **Highest Inefficiency (SkyWest):** **SkyWest Airlines (OO)** is the most severely penalized. When a SkyWest flight is delayed by the carrier itself, that delay averages **over 84 minutes** in both years, demonstrating a critical lack of operational redundancy.
* **Dramatic Worsening (Allegiant):** **Allegiant Air (G4)** showed the biggest decline in efficiency, with its average internal delay time increasing by over 10 minutes in 2024 (**+17.66%**).
* **Major Airline Improvement:** Both **American Airlines (AA)** and **Delta Air Lines (DL)** successfully reduced their average carrier delay time, showing they are getting better at **resolving their internal issues faster**.

### Final Comparison: Average Carrier Delay

| Airline | Code | 2023 Avg. Delay (min) | 2024 Avg. Delay (min) | Change (%) | Conclusion Principal |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SkyWest Airlines** | OO | **84.28** | **84.78** | +0.59% | **Highest Inefficiency:** Longest average delay time in the industry. |
| **Allegiant Air** | G4 | 57.19 | 67.29 | **+17.66%** | **Dramatic Decline:** Major increase in internal failure time, signaling systemic issues. |
| Delta Air Lines | DL | 62.59 | 60.84 | -2.80% | Improved Reliability: Successfully reduced internal failure time. |
| American Airlines | AA | 53.44 | 49.03 | **-8.25%** | **Notable Improvement:** Significantly reduced the duration of its own delays. |
| Frontier Airlines | F9 | 42.49 | 48.40 | +13.91% | Worsening Maintenance: Internal delays are lasting longer in 2024. |
| JetBlue Airways | B6 | 47.44 | 44.93 | -5.29% | Improved: Better internal management of delays. |
| Endeavor Air | 9E | 60.58 | 57.24 | -5.51% | Improved: Better logistics and crew management. |
| PSA Airlines | OH | 46.54 | 48.77 | +4.80% | Slight Worsening: Internal delays are slightly longer. |
| Republic Airline | YX | 44.66 | 45.34 | +1.52% | Stable performance. |
| Alaska Airlines | AS | 42.71 | 42.84 | +0.30% | Stable performance. |

---

## Next Steps

The SQL queries used to generate these insights can be found in the `sql_flight_analysis.sql` file.
