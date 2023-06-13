library(shiny)
library(shinydashboard)
library(DT)
library(caret)
library(xgboost)
library(Matrix)
library(dplyr)
library(ggplot2)
library(shinyjs)

# Define UI for application 
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "ML Shiny Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Raw Data", tabName = "rawdata"),
      menuItem("Machine Learning", tabName = "ml"),
      menuItem("Dashboard", tabName = "dashboard")
    )
  ),
  dashboardBody(
    useShinyjs(),
    tags$head(tags$style(HTML('/* main sidebar */
                                .skin-black .main-sidebar {
                                background-color: #FFFFFF;
                                }
    
                               /* body */
                                .content-wrapper, .right-side {
                                background-color: #FFFFFF;
                                }'))),
    tabItems(
      tabItem("rawdata",
              fluidPage(
                tabsetPanel(
                  id = "dataset",
                  tabPanel("Iris dataset", DT::dataTableOutput("table"))
                  )
              )),
      tabItem("ml",
              p("Train an XGBoost Classifier on Iris dataset"),
              sliderInput("split", label = "Train Test Random Split", value = 0.8,
                          min = min(0),
                          max = max(1),
                          ),
              actionButton("trainbutton", "Train"),
              actionButton("predictbutton", "Predict"),
              verbatimTextOutput('contents')),
      tabItem("dashboard",
              p("Confusion Matrix and Statistics"),
              fluidPage(
                plotOutput("cmplot"),
                verbatimTextOutput("cmstats")
              ))
    )
  )
)



# Define server logic 
server <- function(input, output) {

    output$table <- DT::renderDataTable({
      #DT - an R interface to the JavaScript DataTable library
      DT::datatable(iris, options = list(lengthMenu = c(5, 10, 15), pageLength = 5))
    })
    
    paramInput <- reactive({input$split})
    
    output$contents <- renderPrint({
      
      observe({
        shinyjs::hide("predictbutton")
      })
      
      if (input$trainbutton>0) {
        
        print("Starting training...")
        
        observeEvent(input$split, {
          toggleState("trainbutton")
        })
        
        observe({
          shinyjs::disable("trainbutton")
        })
        
        set.seed(42) 
        
        train_index <- caret::createDataPartition(iris$Species, p=paramInput(), list = FALSE)
        train_set <- iris[train_index,] # Training Set
        test_set <- iris[-train_index,] # Test Set
        
        trainset_labels <- as.integer(train_set$Species) - 1
        trainset_mat <- Matrix(as.matrix(train_set[, -length(train_set)]), sparse = TRUE)
        print("Training set")
        print(dim(trainset_mat))
        print(head(trainset_mat))
        print(trainset_labels)
        
        
        testset_labels <- as.integer(test_set$Species) - 1
        testset_mat <- Matrix(as.matrix(test_set[, -length(test_set)]), sparse = TRUE)
        print("Test set")
        print(dim(testset_mat))
        print(head(testset_mat))
        print(testset_labels)
        
        print("Model")
        
        xgbmodel <- xgboost(data = trainset_mat, label=trainset_labels,
                          max_depth=2, eta=1, nthread=2, nrounds=20, 
                          num_class = 3, objective="multi:softprob", eval_metric="mlogloss")
        
        #print(xgbmodel)
        #print(xgb.model.dt.tree(colnames(trainset_mat), xgbmodel))
       
        print("Training completed.")
        
        #saveRDS(model, "xgboost_model.rds")
        
        #importance_mat <- xgb.importance(feature_names = colnames(trainset_mat), model = xgbmodel)
        #xgb.plot.importance(importance_matrix = importance_mat)
        
        observe({
          shinyjs::show("predictbutton")
        })
       
        if (input$predictbutton>0) {
          print("Predicting on test set.")
          pred <- predict(xgbmodel, testset_mat)
          pred <- matrix(pred, nrow=nrow(testset_mat), byrow = TRUE)
          xgbpred <- as.data.frame(ifelse(pred > 0.5, 1, -1)) 
          xgbpred$pred <- if_else(xgbpred$V1==1, 0, -1)
          xgbpred$pred2 <- if_else(xgbpred$V2==1, 1, xgbpred$pred)
          xgbpred$pred3 <- if_else(xgbpred$V3==1, 2, xgbpred$pred2)
          
          xgbpred_final <- test_set %>%
            mutate(actual = testset_labels) %>%
            mutate (pred = xgbpred$pred3)
          print(xgbpred_final)
          
          output$cmplot <- renderPlot({
            cm <- caret::confusionMatrix(factor(xgbpred$pred3), factor(testset_labels))
            plt <- as.data.frame(cm$table)
            plt$Prediction <- factor(plt$Prediction, levels=rev(levels(plt$Prediction)))
            
            
            ggplot(plt, aes(Prediction, Reference, fill= Freq)) +
              geom_tile() + 
              geom_text(aes(label=Freq)) +
              scale_fill_gradient(low="#f5f5f5", high="#d3d3d3") + 
              theme_light()
          },
          width = 450,
          height = 400
          )
          
          output$cmstats <- renderPrint({
            caret::confusionMatrix(factor(xgbpred$pred3), factor(testset_labels))
          })
          observe({
           shinyjs::hide("predictbutton")
          })
          observe({
            shinyjs::hide("trainbutton")
          })
        }
        
      } 
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
