/*-------------------------------------------------------------
  Program:    Generate_Synthetic_CreditRisk_Data
  Purpose:    Create a sample dataset of 10,000 observations
              with commonly used variables in credit risk.
  -------------------------------------------------------------*/

data credit_risk;
    /* Set a seed for reproducibility */
    call streaminit(12345);

    do Customer_ID = 1 to 10000;
        
        /* ---------------------------
           1. Demographic Variables
           ---------------------------*/
           
        /* Age: Uniform distribution between 21 and 75 */
        Age = floor(21 + (75 - 21)*rand("Uniform"));
        
        /* Years_on_Job: More likely to be smaller for younger, 
           larger for older, but keep it within 0–40 */
        Years_on_Job = min(floor(Age - 18), 40); 
        if Years_on_Job < 0 then Years_on_Job = 0;

        /* ----------------------------
           2. Financial Variables
           ----------------------------*/
           
        /* Annual_Income: Lognormal-like distribution (approx.) 
           to represent skewed real-world incomes. We scale 
           a lognormal(Mean=0, Std=1) and then offset. */
        Annual_Income = round( exp(rand("Normal", 10, 0.5)) , 100 );

        /* Credit_Score: Approx. normal distribution, limited to 300–850. 
           The distribution is centered around 680 with some spread. */
        Credit_Score = round(max(300, min(850, rand("Normal", 680, 70))));

        /* Number_of_Open_Accounts: Typically between 1 and 25 for many consumers. */
        Number_of_Open_Accounts = ceil(25*rand("Uniform"));

        /* Monthly_Debt: 
           Let’s approximate monthly debt payment as a fraction of Annual_Income. 
           Typically around 10%-40% but can vary more widely. */
        Monthly_Debt = round( (0.1 + 0.3*rand("Uniform")) * (Annual_Income/12), 10 );

        /* Revolving_Balances: Some fraction of Annual_Income, 
           again very rough approximation. */
        Revolving_Balances = round( (0.05 + 0.25*rand("Uniform")) * Annual_Income , 100 );

        /* ------------------------------
           3. Credit Behavior Variables
           ------------------------------*/

        /* Average_Utilization_Ratio: Typically between 0% and 100% 
           (expressed here as a decimal from 0.0 to 1.0). */
        Average_Utilization_Ratio = round(rand("Uniform"), 2);

        /* Num_of_30DPD (Number of 30-day-past-due occurrences 
           in last 12 months): small integer, often 0–3. */
        Num_of_30DPD = rand("Integer", 0, 3);

        /* Num_of_90DPD (Number of 90-day-past-due occurrences 
           in last 12 months): can be 0–2. */
        Num_of_90DPD = rand("Integer", 0, 2);

        /* Bankruptcies: Typically 0 or 1, rarely >1 in short window. */
        Bankruptcies = (rand("Uniform") < 0.08);

        /* ----------------------------
           4. Derived/Target Variable
           ----------------------------
           We define a probability of default (p) based on a simple
           logistic-like function of key variables. This is purely
           illustrative and does not represent actual credit models.
        */
        
        /* Example logistic function:
           logit(p) = -8
                      + 0.02*(Age)
                      - 0.0003*(Annual_Income)
                      - 0.025*(Credit_Score)
                      + 0.4*(Bankruptcies)
                      + 0.6*(Num_of_90DPD)
                      + 0.8*(Average_Utilization_Ratio);
           p = exp(logit) / (1 + exp(logit));
        */
        length default_flag 3;
        logit_p = -8
                  + 0.02*Age
                  - 0.0003*Annual_Income
                  - 0.025*Credit_Score
                  + 0.4*Bankruptcies
                  + 0.6*Num_of_90DPD
                  + 0.8*Average_Utilization_Ratio;

        p = exp(logit_p)/(1 + exp(logit_p));

        /* Default_Flag: 1 if default, 0 if non-default */
        if rand("Uniform") < p then Default_Flag = 1;
        else Default_Flag = 0;

        output;
    end;
run;

/* Quick summary to validate data distribution */
proc means data=credit_risk n mean std min max;
    var Age Years_on_Job Annual_Income Credit_Score Number_of_Open_Accounts 
        Monthly_Debt Revolving_Balances Average_Utilization_Ratio
        Num_of_30DPD Num_of_90DPD Bankruptcies Default_Flag;
run;
