import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_table("./question2-1.txt", sep=r"\s*[|]\s*", engine="python")
df["period"] = pd.to_datetime(
    df["rental_year"].astype("str") + "-" + df["rental_month"].astype("str")
)

grouped = df.groupby("store_id")
store_1 = grouped.get_group(1)
store_2 = grouped.get_group(2)

df_plot = pd.DataFrame(
    {
        "period": store_1["period"].values,
        "store_2_count": store_2["count_rentals"].values,
        "store_1_count": store_1["count_rentals"].values,
    }
)
df_plot.sort_values(by="period", inplace=True)

df_plot["period"] = (df_plot["period"].astype("str")).str.extract(r"(^\d{4}-\d{2})")
# print(df_plot)

df_plot.plot(
    x="period",
    y=["store_1_count", "store_2_count"],
    kind="barh",
    label=["Store 1", "Store 2"],
)

plt.title(
    "Number of rentals for each store,\nfor each month on the dataset",
    {"weight": "bold"},
)
plt.xlabel("Number of rentals")
plt.ylabel("Month period")
plt.tight_layout()
plt.grid(visible=True, axis="x", linestyle="--", alpha=0.15, color="k")
plt.show()
