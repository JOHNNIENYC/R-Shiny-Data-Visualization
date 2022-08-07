
dashboardPage(
  dashboardHeader(title = "US Job Market"),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Welcome Page", tabName = "welcomepage", icon = icon("info")),
      menuItem("United States", tabName = "unitedstates", icon = icon("globe")),
      menuItem("US State", tabName = "state", icon = icon("robot")),
      menuItem("Occupation Type", tabName = "occupationtype", icon = icon("flag")),
      menuItem("Data Table", tabName = "dashboard", icon = icon("user"))
        )
   ),
  dashboardBody(
    tabItems(
    tabItem(
      tabName = "welcomepage",
      fluidRow(
        column(
          width = 12,
          tags$h1("Explore US Salary from Year 2016 to 2020"),
          tags$h3("Introduction"),
          tags$p("This interactive Shiny App is designed to help users to explore US salaries and gain meaningful insights by comparing among different occupations/states in different years (from 2016 to 2020). The app mainly contains 3 tabs for interactive analysis, which include United States, US State, and Occupation Type."),
          br(),
          tags$h4("United States", style="text-decoration:underline"),
          tags$p("Select a year, hover over the map and put the mouse pointer in each state to display annual salary(average) in the state. In addition, 3 boxes above the map automatically show number of employment, occupation with highest pay, and US state with the highest pay for the year selected."),
          br(),
          tags$h4("US State", style="text-decoration:underline"),
          tags$p("Select a US state. In the trend tab, explore the trend of salary change for differnt occupations from 2016 to 2020. In the explore tab, select an occupation then explore further about the occupation by looking at its sub-categories."),
          br(),
          tags$h4("Occupation Type", style="text-decoration:underline"),
          tags$p("Select an occupation type. In the trend tab, search one or multiple US states to explore the trend of salary change for the states seleted. In the explore tab, select a year to view the top 10 states with the highest salary in the year selected."),
          br(),
          tags$h4("Data Scource", style="text-decoration:underline"),
          tags$p("The dataset used for this Shiny App is downloaded from US Bureau of Labor Statisitcs: https://www.bls.gov/oes/tables.htm.")
        )
      )
    ),
    tabItem(tabName = "unitedstates",
    fluidRow(
      column(
      selectInput(
                 "year",
                 "Select Year:",
                 choices = unique(df_consolidate$YEAR),
                 selected = 2018),
                  offset = 0.5, width = 6),
      tabBox(
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1", height = "1000px",width = 12,
        tabPanel("National data", 
                 fluidRow(
                 infoBoxOutput("count_total_employment"),
                 infoBoxOutput("count_top_state_salary"),
                 infoBoxOutput("count_top_occupation_salary")
                 ),
                 fluidRow(
                  column(12,
                  htmlOutput("map"),)
                         )
                 ),
        
        tabPanel("Explore",
          box (title = "Top 10 States with Highest Annual Salary", plotlyOutput("top_state_mean_salary"), width = 6),
          box (title = "Top 10 Occupations with Highest Annual Salary", plotlyOutput("top_occupation_mean_salary"), width = 6)
                )
            ) 
         )
         ),
  tabItem(
    tabName = "state",
    fluidRow(
      column(
      selectInput(
        "state",
        "Select State:",
        choices = unique(df_consolidate$STATE),
        selected = "New York"),
       offset = 0.5, width = 6)),
    fluidRow(
    tabBox(
      id = "tabset1", height = "1000px",width = 12,
      tabPanel("Trend",
               
              box (plotlyOutput("trend_occupation_mean_salary"), width = "100%",height = "100%")
      ),
      tabPanel (
      "Explore",
      fluidRow(
        column(
        selectInput(
          "Occupation",
          "Select Occupation:",
          choices = unique(df_join_major$OCC_TITLE),
          selected = "Computer and Mathematical Occupations"),
         offset = 0.5, width = 6)),
      fluidRow(
              box (plotlyOutput("trend_detailed_occupation_mean_salary"), width = 12)
              )
              )
         ))
       ),
  tabItem(
    tabName = "occupationtype",
    fluidRow(
      column(
        selectInput(
          "Major_occupation",
          "Select Occupation:",
          choices = unique(df_join_major$OCC_TITLE),
          selected = "Management Occupations"),
         offset = 0.5, width = 12)),
    fluidRow(
      tabBox(
        id = "tabset1", height = "1000px",width = 12,
        tabPanel("Trend",
                 fluidRow(
                     column(12,
                     selectizeInput(
                         "select_state",
                         "Search one or multiple states",
                         choices = unique(df_join$STATE),
                         selected = "New York", width = "400px",
                         multiple = T
                       ))
                        ),
                 fluidRow(
                   column(12,
                         box (title = "Trend of Annual Salary in Different US States", plotlyOutput("trend_state_mean_salary_byOccupation", width = "100%",height = "100%"))
                        )
                        )
              ),
        tabPanel (
          "Explore",
          fluidRow(
            column(
              selectInput(
                "year_occupation",
                "Select Year:",
                choices = unique(df_consolidate$YEAR),
                selected = "2016"),
                offset = 0.5, width = 6)),
          fluidRow(
                  box (title = "Top 10 State with Hightest Annual Salary (Average)", plotlyOutput("top_state_mean_salary_byOccupation"), width = 12)
                  ))
                  ))
                  ),
  tabItem(
    tabName = "dashboard",
    br(),
    br(),
    br(),
    br(),
    tabsetPanel(
        tabPanel(
              dataTableOutput("USsalary"))
               )
        ) 
        )
        )
)



