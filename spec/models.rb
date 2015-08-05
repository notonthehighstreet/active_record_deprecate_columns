class BrandNewObject < ActiveRecord::Base
end

class User < ActiveRecord::Base
  deprecate_column :old_name
  deprecate_column "old_name_as_string"
end

class Vehicle < ActiveRecord::Base
  deprecate_column :not_used
end
