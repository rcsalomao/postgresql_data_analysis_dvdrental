import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_table("./question1-1.txt", sep=r"\s*[|]\s*", engine="python")
grouped = df.groupby("name")
labels = [group for group in grouped.groups]
values = [grouped.get_group(group)["count"] for group in labels]

plt.title("Number of times each movie has been rented out", {"weight": "bold"})
plt.xlabel("Number of rentals")
plt.ylabel("Film category")
plt.boxplot(values, labels=labels, whis=(0, 100), vert=False)
plt.tight_layout()
plt.grid(visible=True, axis="x", linestyle="--", alpha=0.15, color="k")
plt.gca().invert_yaxis()
plt.show()
