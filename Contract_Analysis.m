close all
clear all

%fname=input('What is the name of the file to load?  ','s');
vars=load('AT12.txt');
col=1;
force=vars(:,col);
time=[0:0.001:((length(force)-1)/1000)];
plot(time, force);


c=0;
while c==0;
    freq=input('Enter cutoff frequency for Low Pass Filter:  ');
    [a,b]=butter(4,freq/500,'low');
    filtforce=filtfilt(a,b,force);
    subplot(2,1,1), plot(force)
    subplot(2,1,2), plot(filtforce)
    c=input('Enter 1 if data is ok, or 0 to change filter frequency:  ');
end

filtforce=filtforce.*9.80665;

plot(time, filtforce);
[x,y] = ginput(2);

% Find array indices associated with the subset of data
temp = abs(time - x(1));
temp = temp - min(temp);
x_min = find(~temp);
temp = abs(time - x(2));
temp = temp - min(temp);
x_max = find(~temp);
% Keep the subset of data
clear force_subset;
clear time_subset;
force_subset = filtforce(x_min:x_max);
time_subset = time(x_min:x_max);
close;
figure;
plot(force_subset);
hold;

'pick points close to the minima, then hit return'
[x_min,y_min]=ginput;
x_min=round(x_min);
'pick points close to the maxima, then hit return'
[x_max,y_max]=ginput;
x_max=round(x_max);

k=1;
while k <= length(x_max)
    temp1=x_max(k)-200;
    if temp1 < -1
        temp1 = 1;
    end
    temp2=x_max(k)+200;
    if temp2 > length(force_subset)
        temp2 = length(force_subset);
    end
    [ymax(k),max_ind]=max(force_subset(temp1:temp2));
    xmax(k)=max_ind+temp1-1;
    k=k+1;
end
k=1;
while k <= length(x_min)
    temp3=x_min(k)-100;
    if temp3 < 0
        temp3 = 1;
    end
    temp4=x_min(k)+100;
    if temp4 > length(force_subset);
        temp4 = length(force_subset);
    end
    i=temp4-1;
    z=0;
    while z==0
        if force_subset(i+1) > force_subset(i) & force_subset(i) < force_subset(i-1)
            xmin(k)=i;
            ymin(k)=force_subset(i);
            z=1;
        else
            i=i-1;
        end
    end
    k=k+1;
end

plot(xmax,ymax, 'ro')
plot(xmin,ymin, 'ro')
hold

for i=1:length(xmax)
    up_time(i) = (xmax(i)-xmin(i))/1000;
    relax(i) = ymin(i+1)+(ymax(i)-ymin(i+1))/2;
    twitch_force (i)= force_subset(xmax(i)) - force_subset(xmin(i));
    for m=1:1000
        if force_subset(xmax(i)+m)>relax(i)&relax(i)>force_subset(xmax(i)+m+1);
            relax_ind = xmax(i)+m;
        else 
            continue
        end
        relax_time(i) = (relax_ind-xmax(i))/1000;
    end
    
    
end


for i=1:length(xmax)
    up_time(i) = (xmax(i)-xmin(i))/1000;
    
    relax(i) = ymin(i+1)+(ymax(i)-ymin(i+1))/2;
    twitch_force (i)= force_subset(xmax(i)) - force_subset(xmin(i));
   
    for m=1:1000
        if force_subset(xmax(i)+m)>relax(i)&relax(i)>force_subset(xmax(i)+m+1);
            relax_ind = xmax(i)+m;
        else 
            continue
        end
        relax_time(i) = (relax_ind-xmax(i))/1000;
    end
    
    
end


for i=1:length(xmax)
full_relax_time(i) = (xmin(i+1)-xmax(i))/1000;
end


twitch_force
mean(twitch_force)

twitc_force_tras = transpose(twitch_force)

up_time
mean(up_time)

relax_time
mean(relax_time)

full_relax_time
mean(full_relax_time)






    




    