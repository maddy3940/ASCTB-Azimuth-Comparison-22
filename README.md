# ASCTB-Azimuth-Comparison

This repository contains code and final comparison reports for ASCT+B and Azimuth tables. Details for each organ as well as the overall summary can be found [here](https://github.com/maddy3940/ASCTB-Azimuth-Comparison-22/tree/main/Python/Data/Final)

![ASCT+B Azimuth Alignment - Frame 1](https://user-images.githubusercontent.com/44323045/163524492-d2058f1f-a442-4299-872f-e7bd02b82dc3.jpg)



In the xlsx file for each organ, following sheets are present- 


Az_missing_cts: This sheet contains the rows from Azimuth organ tables where CT/ID is not present but CT/LABEL (RDFS: Label from the source ontology) is present.
             
             Columns - CT/ID - Azimuth CT/ID (Here this cell would be NULL as the CTs are missing)
                       CT/LABEL - Azimuth CT/LABEL (CT ontology label)


Asctb_missing_cts: This sheet contains rows from ASCT+B organ tables where CT/ID is not present but CT/LABEL (RDFS: Label from the source ontology) is present.
             
             Columns - CT/ID - ASCT+B CT/ID (Here this cell would be NULL as the CTs are missing)
                       CT/LABEL - Azimuth CT/LABEL (RDFS:Label from the source ontology)

* Henceforth all the reference to CT/LABEL means RDFS: Label from the source ontology for both Azimuth and ASCT+B

Az_Asctb_cts_perfect_matches: This sheet contains the Azimuth CT/ID and CT/LABEL and ASCT+B CT/ID and CT/LABEL that are present in both the tables. The method used to determine this was as follows- 
Pick all CT/ID (one by one) from Azmiuth and see if its present in ASCT+B table in every level of hierarchy.
            
              Columns - AZ.CT/ID - CT/ID found in Azimuth table.
                       AZ.CT/LABEL - Azimuth CT/LABEL associated with that CT/ID
                        ASCTB.CT/ID - CT/ID found in ASCT+B table.
                       ASCTB.CT/LABEL - ASCTB CT/LABEL associated with that CT/ID
Note - Azimuth CT/ID and Labels is matching to ASCTB CT/ID and Labels respectively as the match was done on the basis of CT/ID.


Az_incorrect_cts: This sheet contains incorrect CT/IDs from Azimuth tables. If a CT/ID does not start with "CL:" then the CT/ID is incorrect or if a CT/ID does start with "CL:" but that CT/ID cannot be found in https://www.ebi.ac.uk/ols/index then the CT/ID is incorrect.

              Columns - CT/ID - Azimuth CT/ID that does not start with "CL:" or cannot be found in Ontology Lookup website 
                       CT/LABEL - Azimuth CT/LABEL associated with the CT/ID
                       
Asctb_incorrect_cts: This sheet contains incorrect CT/IDs from ASCT+B tables. If a CT/ID does not start with "CL:" then the CT/ID is incorrect or if a CT/ID does start with "CL:" but that CT/ID cannot be found in https://www.ebi.ac.uk/ols/index then the CT/ID is incorrect.

              Columns - CT/ID - Asctb CT/ID that does not start with "CL:" or cannot be found in Ontology Lookup website 
                       CT/LABEL - Asctb CT/LABEL associated with the CT/ID
                       

Az_match_tree_crosswalk: This sheet contains details on all Azimuth CTs that are correct (start with "CL:" and found in OLS) but cannot be directly found in ASCTb tables. For each such Azimuth CT we look for its parent CT in the OLS (https://www.ebi.ac.uk/ols/index) and check whether the parent CT can be found in ASCT+B table. We keep on finding the parent CT from OLS until either we find a match in ASCTB or we reach the base cell (that does not have a parent). This finds CTs that are more detailed in Azimuth.

              Columns- AZ.CT/ID - The correct Azimuth CT/ID that is not present in ASCT+B table 
                       AZ.CT/LABEL - Label associated with that CT/ID in Azimuth
                       Match Found - [Yes/No] This tells us whether any parent of that CT/ID is present in ASCT+B table or not.
                       ASCTB.CT/ID - If a match is found for any parent  of the Azimuth CT/ID in ASCTB then this column contains the matched CT/ID.
                       ASCTB.CT/LABEL - CT/LABEL associated with that matched CT/ID (This label is derived from OLS and not ASCTB table)
                       Hierarchy Length - The length of the crosswalk tree that was looked up.
                       Hierarchy - CT/ID(CT/LABEL) >> CT/ID(CT/LABEL)... This column contains information on the parent CTs of the Azimuth CT that were looked up recursively to find a match in ASCTB.
                       
Asctb_match_tree_crosswalk: This sheet contains details on all Asctb CTs that are correct (start with "CL:" and found in OLS) but cannot be directly found in Azimuth tables. For each such Asctb CT we look for its parent CT in the OLS (https://www.ebi.ac.uk/ols/index) and check whether the parent CT can be found in Azimuth table. We keep on finding the parent CT from OLS until either we find a match in Azimuth or we reach the base cell (that does not have a parent). This finds CTs that are more detailed in ASCTB.

              Columns- ASCTB.CT/ID - The correct Asctb CT/ID that is not present in Azimuth table 
                       ASCTB.CT/LABEL - Label associated with that CT/ID in Asctb
                       Match Found - [Yes/No] This tells us whether any parent of that CT/ID is present in Azimuth table or not.
                       AZ.CT/ID - If a match is found for any parent  of the ASCTB CT/ID in Azimuth then this column contains the matched CT/ID.
                       AZ.CT/LABEL - CT/LABEL associated with that matched CT/ID (This label is derived from OLS and not Azimuth table)
                       Hierarchy Length - The length of the crosswalk tree that was looked up.
                       Hierarchy - CT/ID(CT/LABEL) >> CT/ID(CT/LABEL)... This column contains information on the parent CTs of the ASCTB CT that were looked up recursively to find a match in Azimuth.
                       
                       
Asctb_cts_mismatch_final: This sheet contains all the CTs in ASCTB for which a match could not be found in Azimuth even after recursive parent matching (as mentioned before). These CTs can be looked upon to be included in the Azimuth tables.
              
              Columns- ASCTB.CT/ID - The correct ASCTB CT/ID that is not present in Azimuth table even after recursive parent matching
                       ASCTB.CT/LABEL - Label associated with that CT/ID in ASCTB
 
 
Az_cts_mismatch_final: This sheet contains all the CTs in Azimuth for which a match could not be found in Asctb even after recursive parent matching (as mentioned before). These CTs can be looked upon to be included in the ASCTB tables.
              
              Columns- ASCTB.CT/ID - The correct ASCTB CT/ID that is not present in Azimuth table even after recursive parent matching
                       ASCTB.CT/LABEL - Label associated with that CT/ID in ASCTB
 
 
 
