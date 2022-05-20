local Table = {}

function Table.find_first(t, predicate)
  for _, entry in pairs(t) do
    if predicate(entry) then
      return entry
    end
  end
  return nil
end


function Table.contains(t, predicate)
  return Table.find_first(t, predicate) ~= nil
end

return Table
