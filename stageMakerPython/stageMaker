import random
#이 파일이 속한 폴더에서  python stageMaker를 실행하고 복사해서 AppDelegate에 붙여넣으면 됨
def generate_stage():
    stage_data = random.sample(range(0, 27), 9)  # Generate 9 unique random integers between 0 and 26
    return f'realm.add(StageRealm({stage_data}))'

if __name__ == "__main__":
    for i in range(100):  # Generate 200 stages
        print(generate_stage())
