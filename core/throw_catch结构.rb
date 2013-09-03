通过throw/catch跳出嵌套循环
for matrix in data do                         # Process a deeply nested data structure.
  catch :missing_data do                      # Label this statement so we can break out.
    for row in matrix do 
      for value in row do 
        throw :missing_data unless value      # Break out of two loops at once.
        # Otherwise, do some actual data processing here.
      end
    end
  end
  # We end up here after the nested loops finish processing each matrix.
  # We also get here if :missing_data is thrown.
end
