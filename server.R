

function(input, output) {
  
  
 
  output$count_total_employment = renderInfoBox({
    df_total_employment <-df_consolidate %>% filter (., YEAR == input$year, OCC_GROUP == "total")
    infoBox(title = "TOTAL NUMBER OF EMPLOYMENT",
            value = sum(df_total_employment$TOT_EMP),
            icon = icon("credit-card")
            )
  })
  
  
  output$count_top_state_salary = renderInfoBox({
    df_state <-df_consolidate %>% filter (., YEAR == input$year, OCC_GROUP == "total") %>% arrange(., desc(A_MEAN))
    
    infoBox(title = "STATE WITH THE HIGHEST ANNUAL SALARY",
            value = df_state$STATE[1],
            icon = icon("list"))
  })
  
  output$count_top_occupation_salary = renderInfoBox({
    a = df_Major_occupation <- df_consolidate %>% select(.,OCC_TITLE,A_MEAN) %>% filter(., df_consolidate$OCC_GROUP == "major")%>% 
      group_by(.,OCC_TITLE) %>% summarise(., avg =mean(A_MEAN)) %>% arrange(., desc(avg)) %>% top_n(1)
  
    infoBox(title = "OCCUPATION TYPE WITH THE HIGHEST ANNUAL SALARY",
            value = a$OCC_TITLE)
  })
  
  
  
  output$map <- renderGvis({
    
    df_state_map <-df_consolidate %>% filter (., YEAR == input$year, OCC_GROUP == "total") %>% select (., STATE,A_MEAN) 
    
    gvisGeoChart(df_state_map, "STATE", "A_MEAN", options=list(region="US", displayMode="regions", resolution="provinces", width=1200, height=500))

  })
  
  output$top_state_mean_salary = renderPlotly({
    
    df_state <-df_consolidate %>% filter (., YEAR == input$year, OCC_GROUP == "total") %>% arrange(., desc(A_MEAN))
    
    ggplot(head(df_state, 10), aes(x = reorder(STATE, A_MEAN), y = A_MEAN)) + geom_bar(stat = "identity", fill = "#222d32") + 
      coord_flip() +
      labs(x = "", y = "Annual Salary",title = paste ("Year :", input$year)) + theme_light()
  })
  
  output$top_occupation_mean_salary = renderPlotly({
    
    df_occupation <- df_consolidate  %>% filter(., YEAR == input$year, df_consolidate$OCC_GROUP == "major")%>% select(.,OCC_TITLE,A_MEAN)%>% 
      group_by(.,OCC_TITLE) %>% summarise(., avg =mean(A_MEAN)) %>% arrange(., desc(avg))
    
    ggplot(head(df_occupation, 10), aes(x = reorder(OCC_TITLE, avg), y = avg)) + geom_bar(stat = "identity", fill = "#222d32") + 
      coord_flip() +
      labs(x = "", y = "Annual Salary",title = paste ("Year :", input$year)) + theme_light()
  })
  
  output$trend_occupation_mean_salary = renderPlotly({
    
    df_trend_occupation <- df_consolidate %>% select(., OCC_TITLE, A_MEAN, YEAR, STATE, OCC_GROUP) %>% filter(., STATE == input$state, OCC_GROUP == "major")
    
    ggplot(df_trend_occupation, aes(x = YEAR, y = A_MEAN)) + geom_line(aes(color = OCC_TITLE),size = 1.1) + theme_bw() +
      labs(x = "Year", y = "Annual Salary", title = paste("Trend of Annual Salary for Different Types of Occupations","(",input$state,")")) +
      theme(legend.title = element_blank()) +scale_fill_brewer() 
  })
  
  output$trend_detailed_occupation_mean_salary = renderPlotly({
    
    
    df_detailed_occupation <- df_join %>% select(., OCC_TITLE, A_MEAN,  STATE, OCC_GROUP, OCC_TYPE, YEAR) %>% filter(., STATE == input$state, OCC_TYPE == input$Occupation, OCC_GROUP == "detailed")
    
    ggplot(df_detailed_occupation, aes(x = YEAR, y = A_MEAN,color = OCC_TITLE)) + geom_line(size = 1.1) + theme_bw() +
      labs(x = "Year", y = "Annual Salary", title = paste("Trend of Annual Salary for",input$Occupation,"(", input$state, ")")) +
      theme(legend.title = element_blank()) 
    
      
    
  })
  
  output$trend_state_mean_salary_byOccupation = renderPlotly({
    
    df_trend_state_byOccupation <- df_consolidate  %>% select(.,STATE, OCC_TITLE, OCC_GROUP, A_MEAN, YEAR) %>% filter(., STATE %in% input$select_state, OCC_TITLE == input$Major_occupation, OCC_GROUP == "major") %>% arrange(., desc(A_MEAN))
      
    
    ggplot(df_trend_state_byOccupation, aes(x = YEAR, y = A_MEAN)) + geom_line(aes(color = STATE)) + theme_bw() +
      labs(x = "Year", y = "Annual Salary", title = paste("Occupation Type:",input$Major_occupation)) +
      theme(legend.title = element_blank()) +scale_fill_brewer()
    
  })
  
  output$top_state_mean_salary_byOccupation = renderPlotly({
    
    df_top_state_byOccupation <- df_consolidate  %>% select(.,STATE, OCC_TITLE, OCC_GROUP, A_MEAN, YEAR) %>% filter(., YEAR == input$year_occupation, OCC_TITLE == input$Major_occupation, OCC_GROUP == "major") %>% arrange(., desc(A_MEAN))
    
    ggplot(head(df_top_state_byOccupation, 10), aes(x = reorder(STATE, A_MEAN), y = A_MEAN)) + geom_bar(stat = "identity", fill = "#222d32") + 
      coord_flip() +
      labs(x = "", y = "Annual Salary") + theme_light()
  })
  
  output$USsalary = renderDataTable({
    datatable(df_consolidate, rownames = FALSE)
  })
  
}

