classdef Buffer < handle
  properties 
      
      buffer;
      ncol = 1;
      index = 0;
      size;
      stepSize;
      dynamic = 0;
      arrayType;
  end
  methods 
      function obj = Buffer(ncol, bufferSize, stepSize, dynamic, arrayType)
          if nargin<5
            arrayType = 'double';
          end
          
          switch arrayType
              case 'double'
                 
                obj.buffer = zeros(bufferSize, ncol);
              case 'string'
                 obj.buffer = strings(bufferSize, ncol);
              otherwise
                error('Buffer accept only double or string for array Type');
          end
          obj.index = 0;
          obj.size = bufferSize;
          obj.stepSize = stepSize;
          obj.dynamic = dynamic;
          obj.arrayType = arrayType;
          obj.ncol = ncol;
      end
      function data = data(obj, varargin)
          data = obj.buffer(1:obj.index, :);
          
          if ~isempty(varargin);data = data(varargin{:}); end
      end
      
      function newEntry(obj, entryVector)
        obj.prepareForNext;
        obj.buffer(obj.index,:) = entryVector;
      end
      function prepareForNext(obj)
          % prepare the buffer to receive new entries
          %
          % If the buffer is dynamic (b.dynamic) and index reach the end 
          % the buffer size is increased by b.stepSize
          % Otherwhise if it is not dynamic and reach the end the last
          % b.stepSize data are copied to the begining of the buffer to
          % leave space for the other b.stepSize comming
          if (obj.index+1) > obj.size                
             if obj.dynamic
                 
                 old = obj.buffer;
                 %new = obj.arrayConstructor(obj.index+obj.stepSize, obj.ncol);
                 new = zeros(obj.index+obj.stepSize, obj.ncol);
                 switch obj.arrayType
                    case 'double'
                        new = zeros(obj.index+obj.stepSize, obj.ncol);
                        
                    case 'string'
                        new = strings(obj.index+obj.stepSize, obj.ncol);
                       
                     otherwise
                        error('Buffer accept only double or string for array Type');
                        
                 end
                 new(1:obj.index, :) = old(1:obj.index, :);
                 obj.buffer = new;
                  
                    
             else
                 obj.buffer(1:end-obj.stepSize,:) = obj.buffer(obj.stepSize+1:end,:);
                 obj.index = obj.size - obj.stepSize;
             end
          end
          
          obj.index = obj.index + 1;
      end
  end
end