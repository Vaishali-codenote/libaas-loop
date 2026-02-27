module ApplicationHelper
  def status_class(status)
    case status
    when 'pending' then 'bg-yellow-100 text-yellow-800'
    when 'approved', 'active' then 'bg-green-100 text-green-800'
    when 'rejected', 'cancelled' then 'bg-red-100 text-red-800'
    when 'completed' then 'bg-blue-100 text-blue-800'
    when 'available' then 'bg-green-100 text-green-800'
    when 'rented', 'unavailable' then 'bg-red-100 text-red-800'
    else 'bg-gray-100 text-gray-800'
    end
  end
end
