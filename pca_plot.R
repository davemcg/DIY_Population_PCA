library(tidyverse)
library(data.table)
library(ggiraph)
g1k <- read_tsv('./data/1000g_metadata.tsv')
pca <- read.table('./data/akt.pca.txt', sep="", header = F)

plot <- pca %>%
  left_join(g1k, by=c('V1' = 'Sample name')) %>%
  mutate(`Population name` = case_when(grepl('^IG', V1) ~ 'Colombia Cohort',
                                       TRUE ~ `Population name`)) %>%
  ggplot(aes(x=V2, y=V3, colour = `Population name`, tooltip = paste(V1, `Population name`))) +
  geom_point_interactive(alpha=0.4) +
  theme_minimal()
ggiraph(code = print(plot) )


pca %>%
  left_join(g1k, by=c('V1' = 'Sample name')) %>%
  mutate(`Population name` = case_when(grepl('^IG', V1) ~ 'Colombia Cohort',
                                       TRUE ~ `Population name`)) %>%
  ggplot(aes(x=V2, y=V3, colour = `Population name`, tooltip = paste(V1, '-', `Population name`))) +
  geom_point_interactive(alpha=0.4) +
  xlab('PC1') + ylab('PC2') +
  theme_minimal() +
  ggtitle('All Populations')

ggiraph(code = print(plot))

plot <- pca %>%
  left_join(g1k, by=c('V1' = 'Sample name')) %>%
  mutate(`Population name` = case_when(grepl('^IG', V1) ~ 'Colombia Cohort',
                                       TRUE ~ `Population name`)) %>%
  filter(grepl('Colom|Mexi|Peru|Puerto|Spani', `Population name`)) %>%
  ggplot(aes(x=V2, y=V3, colour = `Population name`, tooltip = paste(V1, '-', `Population name`))) +
  geom_point_interactive(alpha=0.4) +
  xlab('PC1') + ylab('PC2') +
  theme_minimal() +
  ggtitle('Spanish + Americas Populations')
ggiraph(code = print(plot))


