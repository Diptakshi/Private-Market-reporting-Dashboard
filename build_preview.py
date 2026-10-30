"""Build preview/dashboard.html from the CSVs in data/.  Run: python preview/build_preview.py"""
import json
from pathlib import Path
import pandas as pd

root = Path(__file__).resolve().parents[1]
d = lambda f: pd.read_csv(root / "data" / f)
dim, cf, bm = d("dim_fund.csv"), d("fact_cashflows.csv"), d("fact_benchmark.csv")
payload = {
    "funds": dim.to_dict("records"),
    "dates": bm.date.tolist(),
    "index": bm.index_level.round(4).tolist(),
    "flows": cf[["fund_id", "date", "call", "distribution", "nav"]].round(4).values.tolist(),
    "targets": d("dim_asset_class.csv").to_dict("records"),
    "pacing": d("pacing_plan.csv").round(2).to_dict("records"),
    "evergreen": d("evergreen_tradeoff.csv").round(4).to_dict("records"),
}
html = (root / "preview" / "template.html").read_text(encoding="utf-8")
(root / "preview" / "dashboard.html").write_text(html.replace("/*__DATA__*/null", json.dumps(payload)), encoding="utf-8")
print("wrote preview/dashboard.html")
