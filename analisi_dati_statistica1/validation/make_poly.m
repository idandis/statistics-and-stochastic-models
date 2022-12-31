function out1 = make_poly(X,deg)
  N = length(X(:, 1));
  data = ones(N, 1);
  for d = 1:deg
      data = [data, X.^d];  
      res = vertcat(data);  
  end
  out1 = res;
end
