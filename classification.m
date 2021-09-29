rng('default');
clear all;
close all;
filename='C:\Users\Bar\Desktop\balanced data.xlsx';
opts = detectImportOptions(filename, 'PreserveVariableNames',true);
opts.VariableNamesRange = 'A1';
opts.DataRange = 'A2';
%opts = setvartype(opts, {'Var2', 'Var5', 'Var20','Var21', 'Var22', 'Var23', 'Var24','Var25','Var26', 'Var29', 'Var30', 'Var32'}, 'int64');
data = readtable(filename, opts,'ReadVariableNames',true);

%selectedData=data(:,[7 8 10 11 15 17 20 24]);
%selectedData=data(:,[1 8 9 12 13 20 24]);
%selectedData=data(:,[1 8 9 17 20 24]);
%selectedData=data(:,[1 8 9 17 20 22 24]);
%selectedData=data(:,[1 11 20 22 24]);
selectedData=data(:,[1 8 9 20 22 24]);


% rescale data
% features=data(:,[8 9 20 22 24]);
% respons=data(:,1);
% x=table2array(features);
% colmin = min(x);
% colmax = max(x);
% rescale_Data = rescale(x,'InputMin',colmin,'InputMax',colmax);
% rescaled_Data=array2table(rescale_Data,'VariableNames',{'MTD', 'STD', 'perc90-Tair', 'CWSI2', 'Cv'});
% selectedData = [respons rescaled_Data];

%Nr = normalize(selectedData,'range');

% 
% %no test
[Accuracy, Precision, Recall, F1, classificationSVM, validationPredictions, trainingData,validationScores, validationAccuracy]=SVM(selectedData);
table= table(validationPredictions);
results= [trainingData  table];

% % ordinal
% [classificationSVM, validationPredictions, trainingData]=SVM_ordinal(selectedData);
% table= table(validationPredictions);
% results= [trainingData  table];




% realY=data(:,1);
% realY = table2array(realY);
%[trainedClassifier, validationAccuracy]=trainClassifierLOGISTIC(cutdata1);
%imp = predictorImportance(classificationTree);
%imp
%[imp,ind]=sort(imp,"descend");
%ylabel('Estimates');
%xlabel('Predictors');
%h2 = gca;
%h2.XTickLabel = classificationTree.PredictorNames(ind);
%[GeneralizedLinearModel, trainedClassifier, validationAccuracy]=DecisionTree(selectedData);

% [Accuracy, Precision, Recall, F1, classificationSVM, validationPredictions, trainingData]=SVM(selectedData);
% 
% table= table(validationPredictions);
% results= [trainingData  table];

%ScoreSVMModel = fitPosterior(classificationSVM);
%[label,scores] = resubPredict(classificationSVM);
%[~,postProbs] = resubPredict(ScoreSVMModel);
% table(realY(1:1012),label(1:1012),scores(1:1012,2),postProbs(1:1012,2),'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score','PosteriorProbability'})
%GeneralizedLinearModel
%imp






%test
% filename='C:\Users\Bar\Desktop\þþ10446-test.xlsx';
% opts = detectImportOptions(filename, 'PreserveVariableNames',true);
% opts.VariableNamesRange = 'A1';
% opts.DataRange = 'A2';
% opts = setvartype(opts, {'Var2', 'Var5', 'Var20','Var21', 'Var22', 'Var23', 'Var24','Var25','Var26', 'Var29', 'Var30', 'Var32'}, 'int64');
% Tdata = readtable(filename, opts,'ReadVariableNames',true);
% 
% testData=Tdata(:,[8 9 20 22 24]);
% 
% testLabels=Tdata(:,1);
% 
% [trainedClassifier, validationAccuracy] = svm_train(selectedData);
% yfit = trainedClassifier.predictFcn(testData);
% x=table2array(testLabels);
% [C,order]= confusionmat(x,yfit);
% confusionchart(C)