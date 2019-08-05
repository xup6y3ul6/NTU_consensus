source("globals.R")

shinyServer(function(input, output, session) {
    
    observe({
        # check if all mandatory fields have a value
        mandatoryFilled <-
            vapply(fieldsMandatory,
                   function(x) {
                       !is.null(input[[x]]) && input[[x]] != "" && input[[x]] != "None selected"
                   },
                   logical(1))
        mandatoryFilled <- all(mandatoryFilled)
        
        # enable/disable the submit button
        shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
    })
    
    formData <- reactive({
        data <- sapply(fieldsAll, function(x) input[[x]])
        data <- c(data, timestamp = epochTime())
        data <- t(data)
        data
    })
    
    # action to take when submit button is pressed
    observeEvent(input$submit, {
        shinyjs::disable("submit")
        shinyjs::show("submit_msg")
        shinyjs::hide("error")
        
        tryCatch({
            saveData(formData())
            shinyjs::hide("form")
            shinyjs::show("thankyou_msg")
        },
        error = function(err) {
            shinyjs::html("error_msg", err$message)
            shinyjs::show(id = "error", anim = TRUE, animType = "fade")
        },
        finally = {
            shinyjs::enable("submit")
            shinyjs::hide("submit_msg")
        })
    })
    
    observeEvent(input$submit_another, {
        shinyjs::reset("form")
        shinyjs::show("form")
        shinyjs::enable("submit")
        shinyjs::hide("thankyou_msg")
        lapply(questions, function(x){ shinyjs::reset(x$ID) })
    })  
    
    observeEvent(input$restart, {
        shinyjs::reset("form")
        shinyjs::show("submit")
        lapply(questions, function(x){ 
            shinyjs::reset(x$ID)
            shinyjs::hide(id = paste0(x$ID, "_answer"))
        })
    })
    
    
    output$responsesTable <- DT::renderDataTable({
        DT::datatable(loadData(),
                      rownames = FALSE,
                      options = list(searching = FALSE, lengthChange = FALSE))
    })
    
    output$downloadBtn <- downloadHandler(
        filename = function() { 
            sprintf("mimic-google-form_%s.csv", humanTime())
        },
        content = function(file) {
            write.csv(loadData(), file, row.names = FALSE)
        }
    )
    
    isAdmin <- reactive({
        !is.null(input$password) && (input$password == adminPassword)
    })
    
    observeEvent(input$confirm, {
        if(isAdmin()) {
            shinyjs::hide("adminPanel")
            shinyjs::show("adminPanelContainer")
        } else {
            shinyjs::show("incorrect_msg", anim = TRUE, animType = "fade")
            shinyjs::reset("password")
        }
    })
    
    observeEvent(input$getAdmit, {
        shinyjs::toggle("adminPanel")
        shinyjs::reset("adminPanel")
        shinyjs::toggle("adminPanelContainer", condition = !input$getAdmit)
    })
    
    observeEvent(input$getAnswer, {
        lapply(questions, function(x){
            shinyjs::show(id = paste0(x$ID, "_answer"))
        })
        shinyjs::show("form")
        shinyjs::hide("thankyou_msg")
        shinyjs::hide("submit")       
    })
    
})
