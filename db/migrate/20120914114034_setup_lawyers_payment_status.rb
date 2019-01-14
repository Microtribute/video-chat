class SetupLawyersPaymentStatus < ActiveRecord::Migration
  def up
    Lawyer.update_all(["payment_status = 'free'"])
    Lawyer.reindex
  end

  def down
    Lawyer.update_all(["payment_status = 'unpaid'"])
    Lawyer.reindex
  end
end
