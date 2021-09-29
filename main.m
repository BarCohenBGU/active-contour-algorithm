clear all;

folder = 'C:\Users\Bar\Documents\תואר\תואר שני\תזה\activecontours';
if ~exist(folder, 'dir')
    mkdir(folder);
end
baseFileName='Data_27_10_2020_daily.xlsx';

InfectedDay= "6";
expNum="10446";

ExcelName = fullfile(folder, baseFileName);
scale= 10:0.1:40;
head=["Y", "exp_num", "plot_num", "image_name", "day_after_infection", "T_avg", "T_min", "T_max", "MTD", "std", "median","perc2", "perc10", "perc25", "perc75", "perc90", "perc98", "IQR", "MAD", "year", "month", "day", "hour", "minute", "second", "millisecond", "Time", "Temp °C", "Humidity %", "Solar Radiation W/m²", "Wind Speed m/sec", "Wind Dir", "Tavg-Tair","Tmin-Tair","Tmax-Tair","median-Tair", "perc2-Tair", "perc10-Tair", "perc25-Tair","perc75-Tair","perc90-Tair","perc98-Tair" scale];
xlswrite(ExcelName ,head, 'data');

for k = 51:51
    j=3;
    %matFileName = sprintf('Avo_00%d.mat', k);
    matFileName = sprintf('Avo_00%d_%d.mat', k,j);
    fullFileName = fullfile('C:\Users\Bar\Documents\תואר\תואר שני\תזה\activecontours\Matlab', matFileName);
    if exist(fullFileName, 'file')
        matData = load(fullFileName);
        data_extraction(matData, matFileName, ExcelName, InfectedDay, expNum, k, folder, j);
    else
		fprintf('File %s does not exist.\n', fullFileName);
    end
end
