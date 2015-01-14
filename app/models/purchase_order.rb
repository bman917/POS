class PurchaseOrder < ActiveRecord::Base
  belongs_to :supplier
end
