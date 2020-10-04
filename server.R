shinyServer(function(input, output) {
  
  kongo = mongo(collection = "data", db = "hello", url = "mongodb://localhost",
                verbose = TRUE)
  
 
    
 
  
  
  output$d1pick1 = renderUI({
    
    pickerInput("d1pick1",
                "Business partner",
                choices = as.character(kongo$distinct("businesspartner")),
                selected = as.character(kongo$distinct("businesspartner")),
                multiple = T
    ) 
    
  })
  
  
  output$d1pick2 = renderUI({
    
    pickerInput("d1pick2",
                "Store",
                choices = as.character(kongo$distinct("store")),
                selected = as.character(kongo$distinct("store")),
                multiple = T
    ) 
    
  })
  
  
  output$d1pick3 = renderUI({
    
    pickerInput("d1pick3",
                "Weekday",
                choices = as.character(kongo$distinct("weekday")),
                selected = as.character(kongo$distinct("weekday")),
                multiple = T
    ) 
    
  })
  
  
  output$d1pick4 = renderUI({
    
    pickerInput("d1pick4",
                "Month",
                choices = as.character(kongo$distinct("month")),
                selected = "January",
                multiple = T
    ) 
    
  })
  
  output$d1pick5 = renderUI({
    
    pickerInput("d1pick5",
                "Level",
                choices = as.character(kongo$distinct("loyalty")),
                selected = as.character(kongo$distinct("loyalty")),
                multiple = T
    ) 
    
  })
  
  output$d1pick6 = renderUI({
    
    pickerInput("d1pick6",
                "Year",
                choices = c(2017,2018,2019),
                selected =c(2017,2018,2019) ,
                multiple = F
    ) 
    
  })
  
  data = reactive({
    
    validate(
      need(input$d1pick1, ""),
      need(input$d1pick2, ""),
      need(input$d1pick3, ""),
      need(input$d1pick4, ""),
      need(input$d1pick5, "")
      
    )
    c = kongo$find()
    c%>%filter(businesspartner %in% input$d1pick1 &
                 store %in% input$d1pick2 &
                 weekday %in% input$d1pick3 &
                 month %in% input$d1pick4 &
                 loyalty %in% input$d1pick5 &
                 year == input$d1pick6)%>%select(products,customer_id)
    
  })
  
  
  
  
  
  
  
  
  output$apriori =renderDataTable({
    c = data()%>%ddply(c("customer_id"), 
                                  function(df1)paste(df1$products, 
                                                     collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
   
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
   
    basket_rules <- apriori(txn,parameter = list(sup = 0.02, conf = 0.1,target="rules"));
    df_basket <- as(basket_rules,"data.frame")
    df_basket
    
    
}  )
  
  output$aprioritxt =renderPrint({
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    print(apriori(txn))
    
    
    
  })
  
  
  output$image = renderPlot({
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    image(txn)
    })
  
  output$item =renderPlot({
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    itemFrequencyPlot(txn, topN = 8)
    
  })
  
  output$group = renderPlot({
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    basket_rules <- apriori(txn,parameter = list(sup = 0.02, conf = 0.1,target="rules"))
    plot(basket_rules, method = "grouped", control = list(k = 5))
  })
  
  
  
  output$listitem= renderPlot({
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    basket_rules <- apriori(txn,parameter = list(sup = 0.02, conf = 0.1,target="rules"))
    
    
    plot(basket_rules, method="graph", control=list(type="items"))
  })
  
  output$rulestrail = renderPlot({
    
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    basket_rules <- apriori(txn,parameter = list(sup = 0.02, conf = 0.1))
    
    
    
    plot(basket_rules,
         
         method = "graph",
         
         control = list(type = "products"))
  })
  
  output$individualrules = renderPlot({
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    basket_rules <- apriori(txn,parameter = list(sup = 0.02, conf = 0.1))
    
    plot(basket_rules,
         
         method = "paracoord",
         
         control = list(reorder = TRUE))
    
    
    
  })
  
  output$interactive = renderPlotly({
    
    c = data()%>%ddply(c("customer_id"), 
                       function(df1)paste(df1$products, 
                                          collapse = ","))
    colnames(c) = c("Customer_id","products")
    c$Customer_id = NULL
    write.csv(c,"ItemList.csv", quote = F, row.names = TRUE)
    txn = read.transactions(file="ItemList.csv", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
    #txn = as(c,"transactions")
    
    txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
    
    basket_rules <- apriori(txn,parameter = list(sup = 0.02, conf = 0.1))
    
    plotly_arules(basket_rules)
  })
  
  
})