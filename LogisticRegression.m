function [Accuracy, Precision, Recall, F1, trainedClassifier, validationAccuracy] = LogisticRegression (trainingData)

% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a table containing the same predictor and response
%       columns as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 04-Mar-2021 09:11:49


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'MTD', 'STD', 'perc90-Tair', 'CWSI2', 'Cv'};
predictors = inputTable(:, predictorNames);
response = inputTable.Y;
isCategoricalPredictor = [false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
% For logistic regression, the response values are assumed to follow a
% binomial distribution.
successClass = true;
failureClass = false;
% Compute the majority response class. If there is a NaN-prediction from
% fitglm, convert NaN to this majority class label.
numSuccess = sum(response);
numFailure = sum(~response);
if numSuccess > numFailure
    missingClass = successClass;
else
    missingClass = failureClass;
end
successFailureAndMissingClasses = [successClass; failureClass; missingClass];
zeroOneResponse = response;
% Prepare input arguments to fitglm.
concatenatedPredictorsAndResponse = [predictors, table(zeroOneResponse)];
% Train using fitglm.
GeneralizedLinearModel = fitglm(...
    concatenatedPredictorsAndResponse, ...
    'Distribution', 'binomial', ...
    'link', 'logit');

% Convert predicted probabilities to predicted class labels and scores.
convertSuccessProbsToPredictions = @(p) successFailureAndMissingClasses( ~isnan(p).*( (p<0.5) + 1 ) + isnan(p)*3 );
returnMultipleValuesFcn = @(varargin) varargin{1:max(1,nargout)};
scoresFcn = @(p) [1-p, p];
predictionsAndScoresFcn = @(p) returnMultipleValuesFcn( convertSuccessProbsToPredictions(p), scoresFcn(p) );

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
logisticRegressionPredictFcn = @(x) predictionsAndScoresFcn( predict(GeneralizedLinearModel, x) );
trainedClassifier.predictFcn = @(x) logisticRegressionPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'CWSI2', 'Cv', 'MTD', 'STD', 'perc90-Tair'};
trainedClassifier.GeneralizedLinearModel = GeneralizedLinearModel;
trainedClassifier.SuccessClass = successClass;
trainedClassifier.FailureClass = failureClass;
trainedClassifier.MissingClass = missingClass;
trainedClassifier.ClassNames = {successClass; failureClass};
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2019b.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'MTD', 'STD', 'perc90-Tair', 'CWSI2', 'Cv'};
predictors = inputTable(:, predictorNames);
response = inputTable.Y;
isCategoricalPredictor = [false, false, false, false, false];

% Perform cross-validation
KFolds = 5;
cvp = cvpartition(response, 'KFold', KFolds);
% Initialize the predictions to the proper sizes
validationPredictions = response;
numObservations = size(predictors, 1);
numClasses = 2;
validationScores = NaN(numObservations, numClasses);
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;
    
    % Train a classifier
    % This code specifies all the classifier options and trains the classifier.
    % For logistic regression, the response values are assumed to follow a
    % binomial distribution.
    successClass = true;
    failureClass = false;
    % Compute the majority response class. If there is a NaN-prediction from
    % fitglm, convert NaN to this majority class label.
    numSuccess = sum(trainingResponse);
    numFailure = sum(~trainingResponse);
    if numSuccess > numFailure
        missingClass = successClass;
    else
        missingClass = failureClass;
    end
    successFailureAndMissingClasses = [successClass; failureClass; missingClass];
    zeroOneResponse = trainingResponse;
    % Prepare input arguments to fitglm.
    concatenatedPredictorsAndResponse = [trainingPredictors, table(zeroOneResponse)];
    % Train using fitglm.
    GeneralizedLinearModel = fitglm(...
        concatenatedPredictorsAndResponse, ...
        'Distribution', 'binomial', ...
        'link', 'logit');
    
    % Convert predicted probabilities to predicted class labels and scores.
    convertSuccessProbsToPredictions = @(p) successFailureAndMissingClasses( ~isnan(p).*( (p<0.5) + 1 ) + isnan(p)*3 );
    returnMultipleValuesFcn = @(varargin) varargin{1:max(1,nargout)};
    scoresFcn = @(p) [1-p, p];
    predictionsAndScoresFcn = @(p) returnMultipleValuesFcn( convertSuccessProbsToPredictions(p), scoresFcn(p) );
    
    % Create the result struct with predict function
    logisticRegressionPredictFcn = @(x) predictionsAndScoresFcn( predict(GeneralizedLinearModel, x) );
    validationPredictFcn = @(x) logisticRegressionPredictFcn(x);
    
    % Add additional fields to the result struct
    
    % Compute validation predictions
    validationPredictors = predictors(cvp.test(fold), :);
    [foldPredictions, foldScores] = validationPredictFcn(validationPredictors);
    
    % Store predictions in the original order
    validationPredictions(cvp.test(fold), :) = foldPredictions;
    validationScores(cvp.test(fold), :) = foldScores;
end

% Compute validation accuracy
correctPredictions = (validationPredictions == response);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);

cc = confusionchart(response,validationPredictions);
correctPredictions = (response == validationPredictions);
Accuracy = sum(correctPredictions)/length(correctPredictions);
Precision = cc.NormalizedValues(2,2)/(cc.NormalizedValues(2,2)+cc.NormalizedValues(1,2));
Recall = cc.NormalizedValues(2,2)/(cc.NormalizedValues(2,2)+cc.NormalizedValues(2,1));
F1= (2*Precision*Recall)/(Precision+Recall);
