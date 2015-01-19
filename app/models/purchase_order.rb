class PurchaseOrder < ActiveRecord::Base
  belongs_to :supplier

  def po_id
    sprintf('%07d', id)
  end

  def details
    "PO##{po_id} #{po_date_short_format} #{supplier.try :name}"
  end

  def po_date_short_format
    date.to_time.to_s(:med) if date
  end

end
