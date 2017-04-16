Current Work in Progress
------------------------

### Fished Tasks

-   Finished Compilation of data from all the sources. I have all the
    variables, that correspond to the literature I hav reviewed so far.
-   Visualisation close to finishing. Need to create a generic function
    to plot, coefficients. Heatmaps and likes are done.
-   ~ 400 0 words in my draft. Includes the introduction, a brief
    literature review (havent written much here) and the methodology
    (includes data sources, and unpolished hypothesis).

### Further Work

-   Finish looking for 2015 crime data. Unfortunately all the crime data
    post 2015 I have are estimations. I realised after looking at the
    codebook that they use only close to 700 ~ 1000 counties to estimate
    for the entire year. Was skewing my results, and so I avoided them.
    But FBI has released the final data for 2015 which I now need
    to include.
-   Finish the literature survey (Due: Wednesday)
-   Finish regressions for sub-crimes. These are also almost over, but
    havent written them down yet.
-   Look at panel instrumental variables

What does the data looks like?
------------------------------

The dataset is currently spread of 9 year, across all the counties in
United States. I have a detailed breakdown of crime in the counties,
with a total rate along with vagrancy, burglary, violent crimes and drug
possesion and sale.

I use median income and the percent of minority individuals in the
county as my major controls.

![% of Americans uninsured by
year](appendix_files/figure-markdown_strict/heatmap-1.png)

![](appendix_files/figure-markdown_strict/visualisation-1.png)

There is a clear positive trend between the two. Weirdly though the
trend vanishes if controlling for the population of the county. Should I
look deeper into the data?

![](appendix_files/figure-markdown_strict/visualisation_pct-1.png)

First Results
-------------

In the tables below, the variables NUI and PCTUI refer to the number of
un-insured and the percentage of uninsured respectively. The results
change marginally, when I include the population of the county as a
control, but not significantly.

Finally, model 3 for both tables tries out a log-linear model. I would
like to include those as my final model. But unfortunately the Rsquares
are nearly half the amount.

\begin{table}[!htbp] \centering 
  \caption{Base Model coefficients} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lccc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
 & \multicolumn{3}{c}{\textit{Dependent variable:}} \\ 
\cline{2-4} 
\\[-1.8ex] & \multicolumn{3}{c}{GRNDTOT} \\ 
\\[-1.8ex] & (1) & (2) & (3)\\ 
\hline \\[-1.8ex] 
 lag.crime & 0.724$^{***}$ & 0.750$^{***}$ & 0.404$^{***}$ \\ 
  & (0.006) & (0.006) & (0.006) \\ 
  & & & \\ 
 NUI & 0.037$^{***}$ &  & 0.144$^{***}$ \\ 
  & (0.002) &  & (0.015) \\ 
  & & & \\ 
 PCTUI &  & 16.118$^{**}$ &  \\ 
  &  & (6.311) &  \\ 
  & & & \\ 
\hline \\[-1.8ex] 
Observations & 28,230 & 28,230 & 26,289 \\ 
R$^{2}$ & 0.422 & 0.417 & 0.169 \\ 
Adjusted R$^{2}$ & 0.350 & 0.344 & 0.063 \\ 
F Statistic & 9,166.864$^{***}$ (df = 2; 25089) & 8,976.132$^{***}$ (df = 2; 25089) & 2,377.312$^{***}$ (df = 2; 23314) \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{3}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table}
\begin{table}[!htbp] \centering 
  \caption{Coefficients with control variables} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lccc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
 & \multicolumn{3}{c}{\textit{Dependent variable:}} \\ 
\cline{2-4} 
\\[-1.8ex] & \multicolumn{3}{c}{GRNDTOT} \\ 
\\[-1.8ex] & (1) & (2) & (3)\\ 
\hline \\[-1.8ex] 
 lag.crime & 0.729$^{***}$ & 0.759$^{***}$ & 0.395$^{***}$ \\ 
  & (0.006) & (0.005) & (0.006) \\ 
  & & & \\ 
 NUI & 0.042$^{***}$ &  & 0.125$^{***}$ \\ 
  & (0.002) &  & (0.017) \\ 
  & & & \\ 
 PCTUI &  & 15.647$^{**}$ &  \\ 
  &  & (6.707) &  \\ 
  & & & \\ 
 MedianIncome & $-$0.015$^{***}$ & $-$0.018$^{***}$ & $-$0.292$^{***}$ \\ 
  & (0.005) & (0.005) & (0.038) \\ 
  & & & \\ 
 unemployed\_pct & $-$45.348$^{***}$ & $-$40.644$^{***}$ & $-$0.090$^{***}$ \\ 
  & (6.511) & (6.698) & (0.008) \\ 
  & & & \\ 
 minority\_pct & $-$190.356 & $-$129.101 & $-$0.015$^{***}$ \\ 
  & (439.857) & (443.682) & (0.005) \\ 
  & & & \\ 
\hline \\[-1.8ex] 
Observations & 27,984 & 27,984 & 24,128 \\ 
R$^{2}$ & 0.461 & 0.455 & 0.181 \\ 
Adjusted R$^{2}$ & 0.393 & 0.386 & 0.068 \\ 
F Statistic & 4,256.350$^{***}$ (df = 5; 24848) & 4,140.862$^{***}$ (df = 5; 24848) & 938.123$^{***}$ (df = 5; 21204) \\ 
\hline 
\hline \\[-1.8ex] 
\textit{Note:}  & \multicolumn{3}{r}{$^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01} \\ 
\end{tabular} 
\end{table}
