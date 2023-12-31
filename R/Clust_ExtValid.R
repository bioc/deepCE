

  #' Clust_ExtValid
  #' @title Cluster Evaluation by External Measures
  #' @param predcpx A list containing predicted complexes.
  #' @param refcpx A list containing reference complexes (i.e.,
  #' CORUM complexes).
  #' @return A list containing the numerical values for each
  #' evaluation metrics.
  #' @author Matineh Rahmatbakhsh, \email{matinerb.94@gmail.com}
  #' @importFrom dplyr ungroup
  #' @importFrom dplyr summarise
  #' @importFrom  dplyr group_by
  #' @description This function evaluate the quality of clusters by comparing
  #' clustering-derived partitions to known labels (i.e., CORUM complexes) and
  #' assess the similarity between them using quality measures including
  #' overlap score (O), sensitivity (Sn), clustering-wise positive predictive
  #' value (PPV), geometric accuracy (Acc), and maximum matching ratio (MMR).
  #' It is recommended to first reduce redundancy in the known reference
  #' complexes via \code{\link{RemoveCpxRedundance}}, then
  #' evaluates the quality of the predicted complexes.
  #' @export
  #' @examples
  #' # Load known reference complexes
  #' data(refcpx)
  #' # Select subset of complexes to be used as an instance sets for predicted
  #' # complexes
  #' predcpx <- refcpx[5:15]
  #' Eval_result <- Clust_ExtValid(predcpx,refcpx)


  Clust_ExtValid <-
    function(predcpx,
             refcpx){

      . <- NULL
      MarginalSum <- NULL
      Ove.Score <-NULL
      PPV.marginal <- NULL
      PPVeachclus <-  NULL
      SN.marginal <- NULL
      Sneachclus <- NULL
      V1 <- NULL
      id_pred <- NULL
      id_ref <- NULL
      size.predcpx <- NULL
      size.refcpx <- NULL

      if(!is.list(predcpx)){
        stop("Predicted complexes must be list")
      }

      if(!is.list(refcpx)){
        stop("Reference complexes must be list")
      }


      names(predcpx) <- paste0(seq_along(predcpx), "_pred")
      names(refcpx) <- paste0(seq_along(refcpx), "_ref")


      #size predcpx
      size.predcpx.l <-
        lapply(predcpx, function (x) length(x))
      names(size.predcpx.l) <- paste0(seq_along(predcpx), "_pred")


      size.pred <-
        do.call(rbind, size.predcpx.l) %>%
        as.data.frame(.) %>% tibble::rownames_to_column("id_pred") %>%
        dplyr::rename(size.predcpx=V1)



      #size refcpx
      size.refcpx.l <-
        lapply(refcpx, function (x) length(x))
      names(size.refcpx.l) <- paste0(seq_along(size.refcpx.l), "_ref")


      size.ref <-
        do.call(rbind, size.refcpx.l) %>%
        as.data.frame(.) %>% tibble::rownames_to_column("id_ref") %>%
        rename(size.refcpx=V1)




      #compute the intersect of predcpx and refcpx
      result.df <- unlist(lapply(predcpx, function(X) {
        lapply(refcpx, function(Y) {
          length(intersect(X, Y))
        })
      }), recursive=FALSE)

      pair <- strsplit(names(result.df), "\\.")
      pair <- do.call(rbind, pair)


      #convert the resultdf to the dataframe
      result.df <-
        do.call(rbind, result.df) %>%
        as.data.frame(.) %>% cbind(., pair) %>% select(2,3,1) %>%
        rename(intersect=V1) %>% rename(id_pred="1") %>%rename(id_ref="2") %>%
        left_join(., size.pred, by = "id_pred") %>%
        left_join(., size.ref,  by = "id_ref")



      metrics <- list()

      Ovescore.cal <-
        result.df %>%
        mutate(Ove.Score = (intersect)^2/(size.predcpx*size.refcpx))%>%
        group_by(id_pred) %>%
        dplyr::slice(which.max(Ove.Score)) %>% #extract maximum connection
        filter(Ove.Score >= 0.25 )  %>%
        ungroup() %>%
        summarise(Ove.Score.f=length(unique(id_pred))/length(predcpx)) %>%
        .$Ove.Score.f



      PPV.cal <-
        result.df %>%
        group_by(id_pred) %>%
        mutate(MarginalSum = sum(intersect)) %>%
        mutate(PPVeachclus = intersect/MarginalSum) %>%
        dplyr::slice(which.max(PPVeachclus)) %>%#
        mutate(PPV.marginal = PPVeachclus * MarginalSum) %>%
        na.omit() %>%
        ungroup() %>%
        summarise(PPV = sum(PPV.marginal)/sum(MarginalSum)) %>%
        .$PPV

      SN.cal <-
        result.df %>%
        mutate(Sneachclus = intersect/size.refcpx) %>%
        group_by(id_ref) %>%
        dplyr::slice(which.max(Sneachclus)) %>%
        mutate(SN.marginal = Sneachclus * size.refcpx) %>%
        na.omit() %>%
        ungroup() %>%
        summarise(Sn = sum(SN.marginal)/sum(size.refcpx)) %>%
        .$Sn




      Ac.cal <- sqrt(as.numeric(PPV.cal) * as.numeric(SN.cal))


      MMR.cal <-
        result.df %>%
        mutate(Ove.Score = (intersect)^2/(size.predcpx*size.refcpx))%>%
        group_by(id_ref) %>%
        filter(intersect > 0 ) %>%
        dplyr::slice(which.max(Ove.Score)) %>%
        ungroup() %>%
        summarise(MMR = sum(Ove.Score)/length(unique(id_ref))) %>%
        .$MMR

      metrics[["PPV"]] <- PPV.cal
      metrics[["Sn"]] <- SN.cal
      metrics[["Accuracy"]] <- Ac.cal
      metrics[["Overlap"]] <- Ovescore.cal
      metrics[["MMR"]] <- MMR.cal


      return(metrics)

    }










