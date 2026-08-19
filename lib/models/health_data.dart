import 'dart:convert';

const String healthDataJson = '''
{
  "user": {
    "name": "Akash Majumdar",
    "age": 28,
    "gender": "Male",
    "lastUpdated": "Aug 2026"
  },
  "overallHealthScore": 74,
  "healthScoreHistory": [68, 70, 72, 71, 74],
  "organs": [
    {
      "id": "heart",
      "name": "Heart",
      "score": 82,
      "status": "good",
      "color": "0xFFFF4567",
      "icon": "favorite",
      "description": "Cardiovascular health is in good shape. Blood pressure and heart rate are within normal ranges.",
      "metrics": [
        {"label": "Heart Rate", "value": "68 bpm", "status": "good", "range": "60–100 bpm"},
        {"label": "Blood Pressure", "value": "118/76", "status": "good", "range": "< 120/80"},
        {"label": "LDL Cholesterol", "value": "102 mg/dL", "status": "warning", "range": "< 100 mg/dL"},
        {"label": "HDL Cholesterol", "value": "58 mg/dL", "status": "good", "range": "> 40 mg/dL"},
        {"label": "Triglycerides", "value": "138 mg/dL", "status": "good", "range": "< 150 mg/dL"}
      ],
      "conditions": [
        {"name": "LDL Borderline High", "severity": "mild", "description": "LDL cholesterol slightly above optimal level. Dietary adjustments recommended."}
      ],
      "chartData": [72, 75, 78, 80, 79, 82]
    },
    {
      "id": "lungs",
      "name": "Lungs",
      "score": 78,
      "status": "good",
      "color": "0xFF00BFFF",
      "icon": "air",
      "description": "Pulmonary function is within normal ranges. Breathing capacity is healthy.",
      "metrics": [
        {"label": "FVC", "value": "4.8 L", "status": "good", "range": "> 4.0 L"},
        {"label": "FEV1", "value": "3.9 L", "status": "good", "range": "> 3.2 L"},
        {"label": "FEV1/FVC Ratio", "value": "81%", "status": "good", "range": "> 70%"},
        {"label": "O2 Saturation", "value": "98%", "status": "good", "range": "> 95%"},
        {"label": "Peak Flow", "value": "580 L/min", "status": "warning", "range": "> 620 L/min"}
      ],
      "conditions": [
        {"name": "Mild Hyperprolactinemia", "severity": "mild", "description": "Prolactin levels slightly elevated. Under monitoring."}
      ],
      "chartData": [70, 72, 74, 76, 77, 78]
    },
    {
      "id": "brain",
      "name": "Brain",
      "score": 85,
      "status": "good",
      "color": "0xFFBF5FFF",
      "icon": "psychology",
      "description": "Cognitive function and neurological markers are excellent.",
      "metrics": [
        {"label": "Cognitive Score", "value": "92/100", "status": "good", "range": "> 80"},
        {"label": "Sleep Quality", "value": "7.4 hrs", "status": "good", "range": "7–9 hrs"},
        {"label": "Stress Index", "value": "28/100", "status": "good", "range": "< 40"},
        {"label": "HRV", "value": "54 ms", "status": "warning", "range": "> 60 ms"}
      ],
      "conditions": [],
      "chartData": [78, 80, 82, 84, 83, 85]
    },
    {
      "id": "liver",
      "name": "Liver",
      "score": 68,
      "status": "warning",
      "color": "0xFFFF8C42",
      "icon": "bubble_chart",
      "description": "Some liver enzyme levels are slightly elevated. Consider dietary modifications.",
      "metrics": [
        {"label": "ALT", "value": "48 U/L", "status": "warning", "range": "< 40 U/L"},
        {"label": "AST", "value": "38 U/L", "status": "good", "range": "< 40 U/L"},
        {"label": "GGT", "value": "32 U/L", "status": "good", "range": "< 50 U/L"},
        {"label": "Bilirubin", "value": "0.9 mg/dL", "status": "good", "range": "0.2–1.2 mg/dL"}
      ],
      "conditions": [
        {"name": "Mild ALT Elevation", "severity": "moderate", "description": "ALT slightly elevated, monitor alcohol intake and fatty foods."}
      ],
      "chartData": [65, 66, 67, 68, 67, 68]
    },
    {
      "id": "kidney",
      "name": "Kidney",
      "score": 88,
      "status": "good",
      "color": "0xFFFFD166",
      "icon": "water_drop",
      "description": "Renal function is excellent. Filtration rate is optimal.",
      "metrics": [
        {"label": "eGFR", "value": "102 mL/min", "status": "good", "range": "> 90 mL/min"},
        {"label": "Creatinine", "value": "0.92 mg/dL", "status": "good", "range": "0.7–1.3 mg/dL"},
        {"label": "BUN", "value": "14 mg/dL", "status": "good", "range": "7–20 mg/dL"},
        {"label": "Uric Acid", "value": "5.2 mg/dL", "status": "good", "range": "3.5–7.2 mg/dL"}
      ],
      "conditions": [],
      "chartData": [84, 85, 86, 87, 88, 88]
    },
    {
      "id": "gut",
      "name": "Gut",
      "score": 62,
      "status": "warning",
      "color": "0xFF06D6A0",
      "icon": "lunch_dining",
      "description": "Gut microbiome diversity is below optimal. Probiotic supplementation advised.",
      "metrics": [
        {"label": "Microbiome Diversity", "value": "62/100", "status": "warning", "range": "> 70"},
        {"label": "Inflammation Index", "value": "38/100", "status": "warning", "range": "< 30"},
        {"label": "Transit Time", "value": "28 hrs", "status": "good", "range": "20–30 hrs"},
        {"label": "IgA Secretory", "value": "142 mg/dL", "status": "good", "range": "70–230 mg/dL"}
      ],
      "conditions": [
        {"name": "Low Microbiome Diversity", "severity": "moderate", "description": "Gut bacteria diversity is suboptimal. Recommend fiber-rich diet and probiotics."}
      ],
      "chartData": [55, 57, 59, 60, 61, 62]
    },
    {
      "id": "immune",
      "name": "Immune",
      "score": 71,
      "status": "good",
      "color": "0xFF118AB2",
      "icon": "shield",
      "description": "Immune system is functioning adequately. Some inflammatory markers need attention.",
      "metrics": [
        {"label": "WBC Count", "value": "6.2 K/μL", "status": "good", "range": "4.5–11 K/μL"},
        {"label": "CRP", "value": "1.8 mg/L", "status": "warning", "range": "< 1.0 mg/L"},
        {"label": "Vitamin D", "value": "28 ng/mL", "status": "warning", "range": "> 30 ng/mL"},
        {"label": "Zinc", "value": "88 μg/dL", "status": "good", "range": "70–120 μg/dL"}
      ],
      "conditions": [
        {"name": "Mild Inflammation", "severity": "mild", "description": "CRP slightly elevated indicating mild systemic inflammation."},
        {"name": "Vitamin D Insufficiency", "severity": "mild", "description": "Vitamin D levels just below optimal. Supplementation recommended."}
      ],
      "chartData": [65, 67, 68, 70, 71, 71]
    }
  ],
  "bloodMarkers": [
    {
      "category": "Complete Blood Count",
      "markers": [
        {"name": "Hemoglobin", "value": 14.8, "unit": "g/dL", "min": 13.5, "max": 17.5, "status": "good"},
        {"name": "Hematocrit", "value": 43.2, "unit": "%", "min": 41.0, "max": 53.0, "status": "good"},
        {"name": "WBC", "value": 6200, "unit": "cells/μL", "min": 4500, "max": 11000, "status": "good"},
        {"name": "Platelets", "value": 248000, "unit": "cells/μL", "min": 150000, "max": 400000, "status": "good"},
        {"name": "RBC", "value": 5.1, "unit": "M/μL", "min": 4.7, "max": 6.1, "status": "good"}
      ]
    },
    {
      "category": "Metabolic Panel",
      "markers": [
        {"name": "Glucose (Fasting)", "value": 96, "unit": "mg/dL", "min": 70, "max": 100, "status": "good"},
        {"name": "HbA1c", "value": 5.4, "unit": "%", "min": 4.0, "max": 5.7, "status": "good"},
        {"name": "Insulin", "value": 8.2, "unit": "μIU/mL", "min": 2.0, "max": 20.0, "status": "good"},
        {"name": "Sodium", "value": 139, "unit": "mEq/L", "min": 136, "max": 145, "status": "good"},
        {"name": "Potassium", "value": 4.1, "unit": "mEq/L", "min": 3.5, "max": 5.0, "status": "good"}
      ]
    },
    {
      "category": "Lipid Panel",
      "markers": [
        {"name": "Total Cholesterol", "value": 192, "unit": "mg/dL", "min": 0, "max": 200, "status": "good"},
        {"name": "LDL", "value": 102, "unit": "mg/dL", "min": 0, "max": 100, "status": "warning"},
        {"name": "HDL", "value": 58, "unit": "mg/dL", "min": 40, "max": 100, "status": "good"},
        {"name": "Triglycerides", "value": 138, "unit": "mg/dL", "min": 0, "max": 150, "status": "good"},
        {"name": "ApoB", "value": 88, "unit": "mg/dL", "min": 0, "max": 90, "status": "good"}
      ]
    },
    {
      "category": "Thyroid",
      "markers": [
        {"name": "TSH", "value": 2.1, "unit": "mIU/L", "min": 0.4, "max": 4.0, "status": "good"},
        {"name": "Free T4", "value": 1.2, "unit": "ng/dL", "min": 0.8, "max": 1.8, "status": "good"},
        {"name": "Free T3", "value": 3.2, "unit": "pg/mL", "min": 2.3, "max": 4.2, "status": "good"}
      ]
    },
    {
      "category": "Hormones",
      "markers": [
        {"name": "Testosterone", "value": 620, "unit": "ng/dL", "min": 300, "max": 1000, "status": "good"},
        {"name": "Cortisol (AM)", "value": 18.4, "unit": "μg/dL", "min": 6.0, "max": 23.0, "status": "good"},
        {"name": "Prolactin", "value": 18.2, "unit": "ng/mL", "min": 2.0, "max": 18.0, "status": "warning"},
        {"name": "DHEA-S", "value": 312, "unit": "μg/dL", "min": 110, "max": 510, "status": "good"}
      ]
    }
  ],
  "genomics": {
    "score": 76,
    "summary": "Your genetic profile indicates several significant variants affecting metabolism, cardiovascular risk, and immune function.",
    "traits": [
      {"name": "Caffeine Metabolism", "variant": "Fast Metabolizer", "gene": "CYP1A2", "impact": "positive", "description": "You process caffeine rapidly. Up to 400mg/day is safe for you."},
      {"name": "Lactose Tolerance", "variant": "Tolerant", "gene": "LCT", "impact": "positive", "description": "You can metabolize lactose effectively."},
      {"name": "Omega-3 Conversion", "variant": "Low Efficiency", "gene": "FADS1/2", "impact": "negative", "description": "You convert plant-based omega-3 poorly. Marine omega-3 supplementation recommended."},
      {"name": "Vitamin D Absorption", "variant": "Moderate", "gene": "GC/VDR", "impact": "neutral", "description": "Average Vitamin D binding. Moderate sun exposure and supplementation beneficial."},
      {"name": "MTHFR Status", "variant": "C677T Heterozygous", "gene": "MTHFR", "impact": "negative", "description": "Reduced folate metabolism. Methylfolate supplementation may be beneficial."},
      {"name": "APOE Status", "variant": "e3/e3", "gene": "APOE", "impact": "positive", "description": "Average cardiovascular risk profile. Normal Alzheimer risk."},
      {"name": "ACE Genotype", "variant": "ID (Intermediate)", "gene": "ACE", "impact": "neutral", "description": "Moderate ACE activity. Balanced endurance and strength training is optimal."},
      {"name": "Detoxification", "variant": "GST Null", "gene": "GSTM1", "impact": "negative", "description": "Reduced glutathione S-transferase activity. Cruciferous vegetables and NAC supplement beneficial."}
    ],
    "ancestryComposition": [
      {"population": "South Asian", "percentage": 88},
      {"population": "Central Asian", "percentage": 7},
      {"population": "European", "percentage": 3},
      {"population": "East Asian", "percentage": 2}
    ]
  },
  "strengths": [
    {"title": "Strong Kidney Function", "description": "eGFR of 102 places you in the top 20% for your age group.", "icon": "water_drop", "color": "0xFFFFD166"},
    {"title": "Excellent Brain Health", "description": "Cognitive scores and neurological markers well above average.", "icon": "psychology", "color": "0xFFBF5FFF"},
    {"title": "Optimal Blood Glucose", "description": "Fasting glucose and HbA1c are in excellent range, indicating no insulin resistance.", "icon": "monitor_heart", "color": "0xFF00C896"},
    {"title": "Good Cardiovascular Baseline", "description": "Heart rate, blood pressure and HDL levels are all optimal.", "icon": "favorite", "color": "0xFFFF4567"},
    {"title": "Healthy Thyroid", "description": "TSH, T3 and T4 are all within optimal range.", "icon": "bubble_chart", "color": "0xFF4EA8DE"}
  ],
  "weaknesses": [
    {"title": "Low Gut Microbiome Diversity", "description": "Microbiome diversity score is 62, below the 70+ optimal range.", "icon": "lunch_dining", "color": "0xFF06D6A0"},
    {"title": "Vitamin D Insufficiency", "description": "Vitamin D at 28 ng/mL is below the optimal 30+ threshold.", "icon": "wb_sunny", "color": "0xFFFFB547"},
    {"title": "Mild Liver Enzyme Elevation", "description": "ALT is slightly above the 40 U/L upper limit.", "icon": "bubble_chart", "color": "0xFFFF8C42"},
    {"title": "MTHFR Mutation", "description": "C677T heterozygous mutation may impair folate processing.", "icon": "biotech", "color": "0xFFFF5E7D"},
    {"title": "LDL Borderline High", "description": "LDL at 102 mg/dL is above the optimal < 100 threshold.", "icon": "favorite_border", "color": "0xFFFF4567"}
  ],
  "recommendations": [
    {
      "category": "Nutrition",
      "items": [
        {"title": "Increase Dietary Fiber", "description": "Aim for 30g+ fiber daily from legumes, vegetables, and whole grains to improve gut microbiome diversity.", "priority": "high", "icon": "restaurant"},
        {"title": "Reduce Saturated Fats", "description": "Limit red meat and processed foods to help bring LDL cholesterol down to optimal levels.", "priority": "high", "icon": "no_food"},
        {"title": "Add Fermented Foods", "description": "Include yogurt, kefir, or kimchi daily to boost beneficial gut bacteria.", "priority": "medium", "icon": "set_meal"}
      ]
    },
    {
      "category": "Supplements",
      "items": [
        {"title": "Vitamin D3 + K2", "description": "Take 2000-4000 IU Vitamin D3 with K2 daily to reach optimal levels.", "priority": "high", "icon": "medication"},
        {"title": "Marine Omega-3", "description": "2g EPA+DHA daily given your FADS1/2 variant reducing plant-based conversion.", "priority": "high", "icon": "medication"},
        {"title": "Methylfolate (5-MTHF)", "description": "400-800mcg methylfolate preferred over folic acid given MTHFR C677T variant.", "priority": "medium", "icon": "medication"},
        {"title": "Probiotic (Multi-strain)", "description": "High-quality multi-strain probiotic with Lactobacillus and Bifidobacterium to improve gut diversity.", "priority": "medium", "icon": "medication"}
      ]
    },
    {
      "category": "Lifestyle",
      "items": [
        {"title": "Increase Outdoor Activity", "description": "20–30 min of sun exposure between 10am–2pm, 3x per week to help synthesize Vitamin D.", "priority": "medium", "icon": "directions_run"},
        {"title": "Reduce Alcohol", "description": "Keep alcohol below 2 units/week to help normalize ALT enzyme levels.", "priority": "high", "icon": "no_drinks"},
        {"title": "Improve Sleep Consistency", "description": "Aim for 7–8 hrs with consistent bed/wake times to optimize HRV and recovery.", "priority": "medium", "icon": "bedtime"}
      ]
    }
  ]
}
''';

Map<String, dynamic> get healthData => jsonDecode(healthDataJson);
