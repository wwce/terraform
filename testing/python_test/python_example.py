import json
import sys

output = dict()
output['testing'] = dict()
output['testing']['one'] = 'two'

index = 0

for i in sys.argv:
    output[index] = i
    index = index + 1

print(json.dumps(output))

sys.exit(0)
