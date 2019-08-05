source("globals.R")

shinyUI(fluidPage(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(appCSS),
    
    titlePanel("你/妳跟台大熟嗎！？"),
    
    div(
        id = "form",
        class = "margin",
        
        wellPanel(h4("親愛的受訪者："), br(),
                  h4(HTML('&nbsp;'),HTML('&nbsp;'),HTML('&nbsp;'),HTML('&nbsp;'),
                     "您好！本問卷欲了解問卷填答者對於「台大」熟悉程度而所編製的小調查，
                     回答內容僅供問卷開發者研究教學上使用，並不會挪為它用。此外，
                     問卷的回答內容皆會保密，在教學完畢後會直接刪除，因此請安心填答。"),
                  h4(HTML('&nbsp;'),HTML('&nbsp;'),HTML('&nbsp;'),HTML('&nbsp;'),
                     "此問卷內容包含前 2 題的基本資料，接下來共有的 40 題是/非選擇題，
                     題目內容與台大有所相關，請依照自己目前對於台大的認識，選擇題目所敘述的
                     內容是否為真或否。請在所有題目填答完必之前，勿詢問他人或透過網路搜尋答案。
                     在問卷繳交後，您可以查看所有題目的答案與詳解，因此，請遵照自己的能力來填答。
                     您所提供的寶貴意見，對我們的研究將會有所助益，再次感謝您撥空填寫這份問卷。"),
                  h4("台大心理五 林子堯 敬上", class = "align_right"), br(), br()
        ),
        br(),
        
        span("*", class = "font_red"), span("(必填)"), br(), br(),
        
        textInput("name", labelMandatory("你/妳的名字(綽號也行)"), ""),
        sliderInput("num_years", "你/妳在台大生活多少年？", 0, 50, 0, ticks = FALSE),
        
        lapply(questions, function(x) {
            tagList(
                radioButtons(x$ID, labelMandatory(paste0(x$ID, ". ", x$ITEM)), 
                             c("None selected", "True", "False"), inline = TRUE),
                shinyjs::hidden(
                    div(id = paste0(x$ID, "_answer"), class = "answer_bg",
                        strong(x$ANSWER, class = "font_red"), 
                        br(), 
                        x$DETAILED
                    )
                ),
                br()
            )
        }),
        
        actionButton("submit", "Submit", class = "btn-primary"),
        actionButton("restart", "Restart", class = "btn-primary")
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
            span("提交新的回答，"),
            actionLink("submit_another", "Submit another response"),
            br(),
            span("或是你/妳想知道答案的詳解，"),
            actionLink("getAnswer", "Get/Close the answer in detailed."),
            br()
        )
    ),
    
    hr(),
    
    div(
        span("如果你/妳想知道其他人的回答，"),
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
                actionButton("updateBtn", "Update"),
                br(), br(),
                DT::dataTableOutput("responsesTable")
            )
        )
    )
    
))
