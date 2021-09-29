rng('default');
clear all;
close all;
filename='C:\Users\Bar\Desktop\Data_27_10_2020_daily.xlsx';
opts = detectImportOptions(filename, 'PreserveVariableNames',true);
opts.VariableNamesRange = 'A1';
opts.DataRange = 'A2';
%opts = setvartype(opts, {'Var2', 'Var5', 'Var20','Var21', 'Var22', 'Var23', 'Var24','Var25','Var26', 'Var29', 'Var30', 'Var32'}, 'int64');
data = readtable(filename, opts,'ReadVariableNames',true);

group = data{:,3} == 3;
bygroup = data(group,:);

selectedData=bygroup(:,[1 6 7 18 20 21]);


% %no test
[Accuracy, Precision, Recall, F1, classificationSVM, validationPredictions, trainingData,validationScores, validationAccuracy]=SVM(selectedData);
table= table(validationPredictions);
results= [trainingData  table];