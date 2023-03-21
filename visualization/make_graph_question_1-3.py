import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_table("./question1-3.txt", sep=r"\s*[|]\s*", engine="python")
length_categories = [group for group in df.groupby("rental_length_category").groups]
movies_categories = [group for group in df.groupby("category").groups]

labels = {}
for mc in movies_categories:
    category_label = []
    for lc in length_categories:
        category_label.append(mc + "-" + str(lc))
    labels[mc] = category_label

grouped = df.groupby("category")

cmap = plt.get_cmap("tab20c")
color = {}
for i in range(len(movies_categories)):
    color[movies_categories[i]] = cmap(i / len(movies_categories))

for mc in movies_categories:
    plt.barh(
        y=labels[mc],
        width=grouped.get_group(mc)["count"].to_numpy(),
        color=color[mc],
    )
plt.title(
    "Number of movies in each quartile,\naccording to rental duration",
    {"weight": "bold"},
)
plt.xlabel("Number of movies")
plt.ylabel("Film category - Quartile number")
plt.tight_layout()
plt.grid(visible=True, axis="x", linestyle="--", alpha=0.15, color="k")
plt.gca().invert_yaxis()
plt.show()
