data {
	int<lower=2> K;                                        // number of levels
	int<lower=0> N;                                       // number of data points
	int<lower=0, upper=10> y[N];               // rating 
	int<lower=0, upper=1> format[N];       // presentation format
	int<lower=1, upper=K> level[N];           // social distancing levels
}

parameters {
	real betaGM;   // grand mean of the baseline condition (static + none social distancing)
 
	real betaFormat;   // how grand mean changes when format is changed to interactive from static    
 
	real betaMinLevel;  // how grand mean changes when level is changed to min from none
	real betaModLevel;
	real betaExtLevel; 
	
	real betaFMin; 
	real betaFMod;
	real betaFExt;
 		
 	real sigma; // error
}

transformed parameters {
	matrix[K, 4]beta;
	
	beta[1,1] = betaGM;
	beta[1,2] = 0; 
	beta[1,3] = 0; 
	beta[1,4] = 0;
	
	beta[2,1] = betaGM;
	beta[2,2] = betaFormat; 
	beta[2,3] = betaMinLevel; 
	beta[2,4] = betaFMin;
	
	beta[3,1] = betaGM;
	beta[3,2] = betaFormat; 
	beta[3,3] = betaModLevel; 
	beta[3,4] = betaFMod;
	
	beta[4,1] = betaGM;
	beta[4,2] = betaFormat; 
	beta[4,3] = betaExtLevel; 	
	beta[4,4] = betaFExt; 
}

model {
	// priors
	betaGM ~ normal(0, 5);
	
	betaFormat ~ normal(0, 5);
	
	betaMinLevel ~ normal(0, 5);
	betaModLevel ~ normal(0, 5);
	betaExtLevel ~ normal(0, 5);
	
	betaFMin ~ normal(0, 5);
	betaFMod ~ normal(0, 5);
	betaFExt ~ normal(0, 5);
	
	sigma ~ normal(0, 1);
	error ~ normal(0, sigma);
	
	for(n in 1:N) {
		row = level[n];
		y[n] ~ 10 * inv_logit(beta[row, 2] * format[n] + beta[row, 3] * level[n] + beta[row, 4] * format[n] * level[n] + beta[row, 1] + error);  
	}	
}

