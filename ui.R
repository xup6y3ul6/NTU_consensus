source("globals.R")

shinyUI(fluidPage(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(appCSS),
    
    titlePanel("你跟台大熟嗎！？"),
    
    div(
        id = "form",
        
        textInput("name", labelMandatory("Name"), ""),
        textInput("favourite_pkg", labelMandatory("Favourite R package")),
        checkboxInput("used_shiny", "I've built a Shiny app in R before", FALSE),
        sliderInput("r_num_years", "Number of years using R", 0, 25, 2, ticks = FALSE),
        selectInput("os_type", "Operating system used most frequently",
                    c("",  "Windows", "Mac", "Linux")),
        actionButton("submit", "Submit", class = "btn-primary")
    ),
    
    shinyjs::hidden(
        span(id = "submit_msg", "Submitting..."),
        div(id = "error",
            div(br(), tags$b("Error: "), span(id = "error_msg"))
        )
    ),
    
    shinyjs::hidden(
        div(
            id = "thankyou_msg",
            h3("Thanks, your response was submitted successfully!"),
            actionLink("submit_another", "Submit another response")
        )
    ),
    
    hr(),
    
    div(
        span("如果你想知道其他人的回答，"),
        actionLink("getAdmit", "Get/Close the respondence data."),
        br()
    ),
    
    shinyjs::hidden(
        div(id = "adminPanel", 
            passwordInput("password", "Password:"),
            actionButton("confirm", "Confirm"),
            br(), br(),
            shinyjs::hidden(
                div(id = "incorrect_msg", "Incorrect password")
            )
        )
    ),
    
    shinyjs::hidden(
        div(id = "adminPanelContainer",
            wellPanel(
                h2("Previous responses (only visible to admins)"),
                downloadButton("downloadBtn", "Download responses"), 
                br(), br(),
                DT::dataTableOutput("responsesTable")
            )
        )
    ),
    
    div(
        span("或是你想知道答案的想解，"),
        actionLink("getAnswer", "Get/Close the answer in detailed."),
        br()
    )
))
