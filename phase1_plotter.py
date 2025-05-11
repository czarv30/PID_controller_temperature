import matplotlib.patches as patches # Make sure this is imported
import matplotlib.pyplot as plt
import pandas as pd
import polars as pl
import seaborn as sns

def create_plot(df_polars, zoom_x_start, width=11, height=5, y_zoom_limits=(-0.05, 0.1)):

    fig, axes = plt.subplots(1, 2, figsize=(width, height))
    fig.suptitle('Error Signal Analysis: Overview and Zoomed Detail', fontsize=14)

    # Convert to Pandas for Seaborn plotting
    overview_data_pd = df_polars.to_pandas()
    detail_data_pl = df_polars.filter(pl.col('time_ms') > zoom_x_start) # Assuming pl is imported or passed
    detail_data_pd = detail_data_pl.to_pandas()

    # Plot 1: Overview
    sns.scatterplot(data=overview_data_pd, x='time_ms', y='error_signal', ax=axes[0], alpha=0.7)
    axes[0].set_title('Overview: Error Signal vs. Time')
    axes[0].set_xlabel('Time (ms)')
    axes[0].set_ylabel('Error Signal')
    axes[0].grid(True)

    # Plot 2: Zoomed-in Detail
    if not detail_data_pd.empty:
        sns.scatterplot(data=detail_data_pd, x='time_ms', y='error_signal', ax=axes[1], alpha=0.7, color='blue')
        axes[1].set_title(f'Zoomed Detail (time_ms > {zoom_x_start})')
        # axes[1].set_ylim(y_zoom_limits) # Apply zoom
        axes[1].yaxis.tick_right()
        axes[1].yaxis.set_label_position("right")
        axes[1].set_ylabel('Error Signal (Zoomed)')
    else:
        axes[1].set_title(f'No data for time_ms > {zoom_x_start}')
    axes[1].set_xlabel('Time (ms)')
    axes[1].grid(True)

    overview_y_min_ax, overview_y_max_ax = axes[0].get_ylim()
    rect_y_min_on_overview = y_zoom_limits[0]
    rect_height_on_overview = y_zoom_limits[1] - y_zoom_limits[0]
    rect_width = overview_data_pd['time_ms'].max() - zoom_x_start # Or axes[0].get_xlim()[1] - zoom_x_start

    visible_rect_y_min = max(rect_y_min_on_overview, overview_y_min_ax)
    visible_rect_y_max = min(rect_y_min_on_overview + rect_height_on_overview, overview_y_max_ax)
    visible_rect_height = visible_rect_y_max - visible_rect_y_min
    zoom_patch = patches.Rectangle(
                    (zoom_x_start, visible_rect_y_min), # (x,y) bottom-left
                    rect_width,                         # width
                    visible_rect_height,                # height
                    linewidth=1.5,
                    edgecolor='red',
                    facecolor='red',
                    alpha=0.2, # Slight transparency
                    label='Zoomed Region' # For legend, if desired
                )
    axes[0].add_patch(zoom_patch)

    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    return fig