# This script takes all the oxygen data

#The data required is as followd
#row 1 contains metadata, in column1 is cell#, column2 date, column3 exp name
#row 2 contains descriptioni, column1 time, following columns rep names
#row 3 contains mapping info, with replicate condition indicated
#rows 4+ contain data


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))  # Works in RStudio

library(tidyverse)

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)


# Load combined dataset
all_data <- read_csv("all_raw_data.csv")

# Split by experiment_name (correct ordering preserved)
experiments_raw <- split(all_data, all_data$experiment_name)

# build structured experiment list 
experiments <- lapply(experiments_raw, function(df) {
  list(
    name = unique(df$experiment_name),
    cell_number = unique(df$cell_number),
    date = unique(df$experiment_date),
    data = df %>% select(time, replicate, oxygen, condition)
  )
})

############################################################################################################################### FIGURE 1A

fig1a <- experiments[["NO2_dependency_and_revival_exp_12_rep"]]$data

summary_fig1a <- fig1a %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  )

condition_labels1a <- c(
  `0mM_NO2` = "0 mM NO₂",
  `1mM_NO2` = "1 mM NO₂"
)

summary_fig1a <- summary_fig1a %>%
  mutate(condition = condition_labels1a[condition])

colors1a <- c(
  `0 mM NO₂` = "#1B9E77",
  `1 mM NO₂` = "#D95F02"
)


plot_fig1a <- ggplot(summary_fig1a,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.4,
    linewidth = 0.35,
    color = "grey70"     
  ) +
  scale_color_manual(values = colors1a) +
  labs(
    x = "Time (h)",
    y = expression(O[2]~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    plot.title = element_blank(),
    
    # Axis styling
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    # Grid and border
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    # Legend inside plot
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    # Cleaner spacing
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig1a)



ggsave(
  filename = "./figures_to_publish/Fig1a_small.pdf",   
  plot = plot_fig1a ,                          # the ggplot object
  device = "pdf",              
  width = 9, height = 7,          
  units = "cm",
  useDingbats = FALSE,
  dpi = 600                         # dpi is ignored for PDF, but still good practice
)


ggsave(
  filename = "./figures_to_publish/Fig1a_small.png",   
  plot = plot_fig1a ,                          # the ggplot object
  device = "png",              
  width = 9, height = 7,           
  units = "cm",
  dpi = 600                         # dpi is ignored for PDF, but still good practice
)



ggsave(
  filename = "./figures_to_publish/Fig1a_big.pdf",  
  plot = plot_fig1a ,                          # the ggplot object
  device = "pdf",              
  width = 17, height = 10,           
  units = "cm",
  useDingbats = FALSE,
  dpi = 600                         # dpi is ignored for PDF, but still good practice
)


ggsave(
  filename = "./figures_to_publish/Fig1a_big.png",   
  plot = plot_fig1a ,                          # the ggplot object
  device = "png",              
  width = 17, height = 10,           
  units = "cm",
  dpi = 600                         # dpi is ignored for PDF, but still good practice
)



#################################################################################################################################  FIGURE 1B

fig1b <- experiments[["NH4_independence_repeat"]]$data

summary_fig1b <- fig1b %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  )

condition_labels1b <- c(
  `0mM NO2` = "0 mM NO2",
  `1mM NO2 +0mM NH4` = "0 mM NH₄",
  `1mM NO2 +2mM NH4` = "2 mM NH₄"
)

summary_fig1b <- summary_fig1b %>%
  mutate(condition = condition_labels1b[condition])

colors1b <- c(
  `2 mM NH₄` = "#D95F02",
  `0 mM NO2` = "#1B9E77",
  `0 mM NH₄` = "#0041C7"
)

plot_fig1b <- ggplot(summary_fig1b,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.4,
    linewidth = 0.35,
    color = "grey70"       
  ) +
  scale_color_manual(values = colors1b) +
  labs(
    x = "Time (h)",
    y = expression(O[2]~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    plot.title = element_blank(),
    
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig1b)

ggsave(
  filename = "./figures_to_publish/Fig1b_small.pdf",
  plot = plot_fig1b,
  device = "pdf",
  width = 9, height = 7, units = "cm",
  useDingbats = FALSE
)

ggsave(
  filename = "./figures_to_publish/Fig1b_small.png",
  plot = plot_fig1b,
  device = "png",
  dpi = 600,
  width = 9, height = 7, units = "cm"
)

ggsave(
  filename = "./figures_to_publish/Fig1b_big.pdf",
  plot = plot_fig1b,
  device = "pdf",
  width = 17, height = 10, units = "cm",
  useDingbats = FALSE
)

ggsave(
  filename = "./figures_to_publish/Fig1b_big.png",
  plot = plot_fig1b,
  device = "png",
  dpi = 600,
  width = 17, height = 10, units = "cm"
)
#################################################################################################################################  FIGURE 1b-zoom


summary_fig1b_zoom <- summary_fig1b %>%
  filter(time <= 5)

plot_fig1b_zoom <- ggplot(summary_fig1b_zoom,
                          aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.35,
    linewidth = 0.32,
    color = "grey70"
  ) +
  scale_color_manual(values = colors1b) +
  labs(
    x = "Time (h)",
    y = expression(O[2]~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    plot.title = element_blank(),
    
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig1b_zoom)

#################################################################################################################################  FIGURE 1c


FigNO2conc <- experiments[["NO2_conc_effect"]]$data


FigNO2conc_labels <- c(
  `0.05mM_NO2` = "0.05mM NO2",
  `0mM_NO2` = "Control (no NO2)",
  `10mM_NO2` = "10mM NO2"
)


summary_FigNO2conc <- FigNO2conc %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(condition = FigNO2conc_labels[condition]) %>%
  filter(!is.nan(mean_oxygen))

NO2_colors <- c(
  `Control (no NO2)` = "#1B9E77",
  `0.05mM NO2`       = "#c5ff1a",
  `10mM NO2`         = "#B30000"
)

plot_fig1c <- ggplot(summary_FigNO2conc,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.8,
    linewidth = 0.7,
    color = "grey70"
  ) +
  scale_color_manual(values = NO2_colors) +
  labs(
    x = "Time (h)",
    y = expression(O[2]~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    plot.title = element_blank(),
    
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig1c)


ggsave("./figures_to_publish/Fig1c_small.pdf", plot_fig1c,
       width = 9, height = 7, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig1c_small.png", plot_fig1c,
       width = 9, height = 7, units = "cm", dpi = 600)

ggsave("./figures_to_publish/Fig1c_big.pdf", plot_fig1c,
       width = 17, height = 10, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig1c_big.png", plot_fig1c,
       width = 17, height = 10, units = "cm", dpi = 600)




###################################################################################################################################### Fig2


# Load raw file
raw <- read.csv("Recovery_growthcurve.csv", header = FALSE, stringsAsFactors = FALSE)

# First row = condition, second row = replicate
conds <- raw[1, -1]
reps  <- raw[2, -1]

# Build column names
col_names <- c("time", paste(conds, reps, sep = "_"))

# Remove the header rows and assign names
data <- raw[-c(1,2), ]
colnames(data) <- col_names

# Convert to numeric
data <- data %>% mutate(across(everything(), as.numeric))

# Long format
data_long <- data %>%
  pivot_longer(
    cols = -time,
    names_to = c("condition", "replicate"),
    names_sep = "_",
    values_to = "value"
  )

# Summary stats
summary_data <- data_long %>%
  group_by(condition, time) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    sd_value = sd(value, na.rm = TRUE),
    .groups = "drop"
  )

# Matching color scheme
colors2 <- c(
  `no oxygen produced` = "#1B9E77",
  `oxygen produced` = "#D95F02"
)

# plot
plot_fig2 <- ggplot(summary_data,
                    aes(x = time, y = mean_value, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_value - sd_value,
        ymax = mean_value + sd_value),
    width = 0.15,
    linewidth = 0.25,
    color = "grey70"
  ) +
  scale_color_manual(values = colors2) +
  labs(
    x = "Time (days)",
    y = expression(Nitrite~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    plot.title = element_blank(),
    
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig2)


ggsave("./figures_to_publish/Fig2_small.pdf", plot = plot_fig2, device = "pdf",
       width = 9, height = 7, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig2_small.png", plot = plot_fig2, device = "png",
       dpi = 600, width = 9, height = 7, units = "cm")


ggsave("./figures_to_publish/Fig2_big.pdf", plot = plot_fig2, device = "pdf",
       width = 17, height = 10, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig2_big.png", plot = plot_fig2, device = "png",
       dpi = 600, width = 17, height = 10, units = "cm")




################################################################################################################################# Fig3 starvation

starvation_experiment <- experiments[["Starvation_1d_3d_repeat"]]$data

summary_starvation_experiment <- starvation_experiment %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  )

# Fix label typos
condition_labels <- c(
  not_starved = "Control (no starvation)",
  `1d_starvaion` = "Starved (24 hours)",
  `3d_starvation` = "Starved (72 hours)"
)

summary_starvation_renamed <- summary_starvation_experiment %>%
  mutate(condition = condition_labels[condition])

# Matching color scheme:
# Control = oxygen producer color (#D95F02)
# Starved = darker variants
starvation_colors <- c(
  `Control (no starvation)` = "#D95F02",
  `Starved (24 hours)` = "#A34A01",
  `Starved (72 hours)` = "#6C3101"
)

plot_fig3 <- ggplot(summary_starvation_renamed,
                    aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.15,
    linewidth = 0.35,
    color = "grey70"
  ) +
  scale_color_manual(values = starvation_colors) +
  labs(
    x = "Time (h)",
    y = expression(O[2]~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    # No title (journal style)
    plot.title = element_blank(),
    
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig3)


ggsave("./figures_to_publish/Fig3_small.pdf", plot = plot_fig3, device = "pdf",
       width = 9, height = 7, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig3_small.png", plot = plot_fig3, device = "png",
       dpi = 600, width = 9, height = 7, units = "cm")

ggsave("./figures_to_publish/Fig3_big.pdf", plot = plot_fig3, device = "pdf",
       width = 17, height = 10, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig3_big.png", plot = plot_fig3, device = "png",
       dpi = 600, width = 17, height = 10, units = "cm")

################################################################################################################################# Fig3b

summary_starvation_zoom <- summary_starvation_renamed %>%
  filter(time <= 2)

plot_fig3b <- ggplot(summary_starvation_zoom,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(
    aes(group = condition),
    size = 0.8,
    na.rm = TRUE
  )+
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.075,
    linewidth = 0.25,
    color = "grey70"
  ) +
  scale_color_manual(values = starvation_colors) +
  labs(
    x = "Time (h)",
    y = expression(O[2]~"(" * mu * "M)")
  ) +
  theme_minimal(base_size = 8) +
  theme(
    plot.title = element_blank(),
    
    axis.text = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    
    legend.position = c(0.75, 0.85),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    legend.title = element_blank(),
    legend.text = element_text(size = 7),
    
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig3b)



ggsave(
  filename = "./figures_to_publish/Fig3b_small.pdf",
  plot = plot_fig3b,
  device = "pdf",
  width = 9, height = 7, units = "cm",
  useDingbats = FALSE
)

ggsave(
  filename = "./figures_to_publish/Fig3b_small.png",
  plot = plot_fig3b,
  device = "png",
  dpi = 600,
  width = 9, height = 7, units = "cm"
)

ggsave(
  filename = "./figures_to_publish/Fig3b_big.pdf",
  plot = plot_fig3b,
  device = "pdf",
  width = 17, height = 10, units = "cm",
  useDingbats = FALSE
)

ggsave(
  filename = "./figures_to_publish/Fig3b_big.png",
  plot = plot_fig3b,
  device = "png",
  dpi = 600,
  width = 17, height = 10, units = "cm"
)

#
################################################################################################################################### FIGURE 4A

theme_pub <- function() {
  theme_minimal(base_size = 8) +
    theme(
      plot.title = element_blank(),
      axis.text = element_text(size = 7, color = "black"),
      axis.title = element_text(size = 8),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
      legend.position = c(0.75, 0.85),
      legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
      legend.title = element_blank(),
      legend.text = element_text(size = 7),
      plot.margin = margin(2, 2, 2, 2, "mm")
    )
}

O2_additions2 <- experiments[["O2_additions_2"]]$data

summary_O2_additions_2 <- O2_additions2 %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(condition = c(
    undisturbed_production = "Control (1x 98.5 µmol O₂ addition)",
    additions_of_O2 = "3× 197 µmol O₂ additions"
  )[condition]) %>%
  filter(!is.nan(mean_oxygen))

colors_4a <- c(
  `Control (1x 98.5 µmol O₂ addition)` = "#D95F02",
  `3× 197 µmol O₂ additions` = "#F4BB44"
)

plot_fig4a <- ggplot(summary_O2_additions_2,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.4, linewidth = 0.35, color = "grey70"
  ) +
  scale_color_manual(values = colors_4a) +
  labs(x = "Time (h)", y = expression(O[2]~"(" * mu * "M)")) +
  theme_pub()

print(plot_fig4a)

ggsave("./figures_to_publish/Fig4a_small.pdf", plot_fig4a, width = 9, height = 7, units = "cm", dpi = 600)
ggsave("./figures_to_publish/Fig4a_small.png", plot_fig4a, width = 9, height = 7, units = "cm", dpi = 600)




############################################################################################################################### FIGURE 4B

Fig4b <- experiments[["O2_additions_no_NH4"]]$data

summary_Fig4b <- Fig4b %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(condition = c(
    undisturbed = "Control (no additions)",
    added_O2 = "3× 197 µmol O₂ additions"
  )[condition]) %>%
  filter(!is.nan(mean_oxygen))

colors_4b <- c(
  `Control (no additions)` = "#0041C7",
  `3× 197 µmol O₂ additions` = "#2F72FE"
)

plot_fig4b <- ggplot(summary_Fig4b,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.4, linewidth = 0.35, color = "grey70"
  ) +
  scale_color_manual(values = colors_4b) +
  labs(x = "Time (h)", y = expression(O[2]~"(" * mu * "M)")) +
  theme_pub()

print(plot_fig4b)


ggsave("./figures_to_publish/Fig4b_small.pdf", plot_fig4b, width = 9, height = 7, units = "cm")
ggsave("./figures_to_publish/Fig4b_small.png", plot_fig4b, width = 9, height = 7, units = "cm", dpi = 600)


########################################################################################################################### FIG 4C ATU

Fig4c <- experiments[["ATU_additions"]]$data

summary_Fig4c <- Fig4c %>%
  group_by(condition, time) %>%
  summarise(
    mean_oxygen = mean(oxygen, na.rm = TRUE),
    sd_oxygen = sd(oxygen, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(condition = c(
    `noATU` = "Control (no ATU)",
    `3mM_ATU` = "3 mM ATU"
  )[condition]) %>%
  filter(!is.nan(mean_oxygen))

colors_4c <- c(
  `Control (no ATU)` = "#D95F02",
  `3 mM ATU` = "#CF9FFF"
)

plot_fig4c <- ggplot(summary_Fig4c,
                     aes(x = time, y = mean_oxygen, color = condition)) +
  geom_line(size = 0.8) +
  geom_point(size = 2.2) +
  geom_errorbar(
    aes(ymin = mean_oxygen - sd_oxygen,
        ymax = mean_oxygen + sd_oxygen),
    width = 0.4, linewidth = 0.35, color = "grey70"
  ) +
  scale_color_manual(values = colors_4c) +
  labs(x = "Time (h)", y = expression(O[2]~"(" * mu * "M)")) +
  theme_pub()

print(plot_fig4c)


ggsave("./figures_to_publish/Fig4c_small.pdf", plot_fig4c, width = 9, height = 7, units = "cm")
ggsave("./figures_to_publish/Fig4c_small.png", plot_fig4c, width = 9, height = 7, units = "cm", dpi = 600)
########################################################################################################################### 






################################################################################################################################ FIG 5 ALTERNATE


prod_data_grouped <- read_csv("total_prod_data_grouped.csv")



total_condition_order_grouped <- c( "1mM NO2+ 2mMNH4", "0mM NO2","0.05mM NO2+ 2mM NH4","10mM NO2+ 2mMNH4", "1mM NO2+ NO NH4","1day starvation 1mM NO2+ 2mMNH4",  
                                    "3day starvation 1mM NO2+ 2mMNH4", "O2 addition with NH3 + 5.2", "O2 addition with NH3 0.86", "O2 addition NO  NH4 + 3.5", 
                                    "O2 addition 1.73", "ATU + O2 addition 1.73")  # change to your order


prod_summary_grouped <- prod_data_grouped %>%
  group_by(Condition) %>%
  summarise(
    mean_prod = mean(total_production),
    sd_prod = sd(total_production),
    .groups = "drop"
  ) %>%
  mutate(Condition = factor(Condition, 
                            levels = total_condition_order_grouped))



prod_summary_grouped <- prod_summary_grouped %>%
  mutate(Condition = factor(Condition, levels = total_condition_order_grouped))


total_colors_grouped <- c(
  "1mM NO2+ 2mMNH4"                     = "#D95F02",
  "0mM NO2"                             = "#1B9E77",
  "1mM NO2+ NO NH4"                     = "#0041C7",
  "1day starvation 1mM NO2+ 2mMNH4"     = "#A34A01",
  "3day starvation 1mM NO2+ 2mMNH4"     = "#6C3101",
  "O2 addition with NH3 0.86"           = "#D95F02",
  "O2 addition with NH3 + 5.2"          = "#F4BB44",
  "O2 addition NO  NH4 + 3.5"           = "#2F72FE",
  "O2 addition 1.73"                    = "#D95F02",
  "ATU + O2 addition 1.73"              = "#CF9FFF"
)

plot_fig5 <- ggplot(prod_summary_grouped,
                    aes(x = Condition, y = mean_prod, fill = Condition)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_errorbar(
    aes(ymin = mean_prod - sd_prod,
        ymax = mean_prod + sd_prod),
    width = 0.2, linewidth = 0.35, color = "grey40"
  ) +
  scale_fill_manual(values = total_colors_grouped) +
  labs(
    x = "Condition",
    y = "Total O₂ production (amol/cell)"
  ) +
  theme_minimal(base_size = 8) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(size = 7, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 7, color = "black"),
    axis.title = element_text(size = 8),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(linewidth = 0.3, color = "grey85"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    plot.margin = margin(2, 2, 2, 2, "mm")
  )

print(plot_fig5)



ggsave("./figures_to_publish/Fig5_small.pdf", plot_fig5,
       width = 9, height = 7, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig5_small.png", plot_fig5,
       width = 9, height = 7, units = "cm", dpi = 600)




ggsave("./figures_to_publish/Fig5_big.pdf", plot_fig5,
       width = 17, height = 10, units = "cm", useDingbats = FALSE)

ggsave("./figures_to_publish/Fig5_big.png", plot_fig5,
       width = 17, height = 10, units = "cm", dpi = 600)







