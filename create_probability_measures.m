function  p = create_probability_measures(vector,type)

if strcmp(type,'image')==1,

    x1= 0:255;
    p = vertcat(x1, histc(vector(:), 0:255)'/sum(histc(vector(:), 0:255))) ;

else
    
  p1.sym = unique(vector,'stable'); % Unique symbols present in string
  p1.freq = zeros(1,length(p1.sym)); % Preallocating frequency
   
  for k = 1:length(p1.sym)
    p1.freq(k) = length(strfind(vector,p1.sym(k))); % Calculate frequecny
    p1.prob(k) = p1.freq(k)/length(vector);    % Calculate probability
  end

  p=vertcat(double(p1.sym),p1.prob);
end
end