import pandas as pd
import json

excel_path = r"d:\PROCESOS MD\Procesos M&D Piloto.xlsx"
xls = pd.ExcelFile(excel_path)

output = {"sheets": []}

for sheet in xls.sheet_names:
    sheet_info = {"name": sheet, "columns": []}
    try:
        df = pd.read_excel(xls, sheet_name=sheet)
        for col in df.columns:
            sheet_info["columns"].append({
                "name": str(col),
                "type": str(df[col].dtype),
                "null_count": int(df[col].isnull().sum()),
                "unique_count": int(df[col].nunique())
            })
        sheet_info["total_rows"] = len(df)
        
        # sample data
        sample_df = df.head(3)
        # convert dates to string
        sample_df = sample_df.astype(str)
        sheet_info["sample_data"] = sample_df.to_dict(orient="records")
    except Exception as e:
        sheet_info["error"] = str(e)
        
    output["sheets"].append(sheet_info)

with open(r"d:\PROCESOS MD\migracion\excel_analysis.json", "w", encoding="utf-8") as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print("Analysis saved to migracion/excel_analysis.json")
