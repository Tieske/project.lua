-- example to add to documentation

for key, value in pairs(_G) do
  if key:sub(1,1) == "_" and type(value) == "string" then
    key = key:match("^_+(.+)$")
    print(key, value)
  end
end
