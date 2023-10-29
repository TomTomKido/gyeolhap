# import random
# #이 파일이 속한 폴더에서  python stageMaker를 실행하고 복사해서 AppDelegate에 붙여넣으면 됨

# #hard mode: 답이 10개 이상 혹은 2개 이하 스테이지 생성
# def generate_stage():
#     stage_data = random.sample(range(0, 27), 9)  # Generate 9 unique random integers between 0 and 26

#     # return f'realm.add(StageRealm({stage_data}))'

# if __name__ == "__main__":
#     for i in range(100):  # Generate 200 stages
#         print(generate_stage())

import math
import random

class StageRealm:
    def __init__(self, stage_data):
        self.stage_data = stage_data

    def getArrayData(self):
        return self.stage_data

def get_colors(array):
    return [val % 3 for val in array]

def get_shapes(array):
    return [int(math.floor(val / 3)) % 3 for val in array]

def get_bg_colors(array):
    return [int(math.floor(math.floor(val / 3) / 3)) % 3 for val in array]

def solver(stage):
    answers = []
    data_array = stage.getArrayData()
    colors = get_colors(data_array)
    shapes = get_shapes(data_array)
    bg_colors = get_bg_colors(data_array)

    for i in range(9):
        for j in range(i + 1, 9):
            for k in range(j + 1, 9):
                if (colors[i] + colors[j] + colors[k]) % 3 != 0:
                    continue
                if (shapes[i] + shapes[j] + shapes[k]) % 3 != 0:
                    continue
                if (bg_colors[i] + bg_colors[j] + bg_colors[k]) % 3 != 0:
                    continue
                answer = [i+1, j+1, k+1]
                answers.append(answer)

    return answers

def generate_stage():
    stage_data = random.sample(range(0, 27), 9)  # Generate 9 unique random integers between 0 and 26
    stage = StageRealm(stage_data)
    return stage


def make1Stage():
    stage = generate_stage()
    solution = solver(stage)
    print(solution)

def make_hard_stage():
    # Example Usage:
    hard_stage = []
    for i in range(100000):
        stage = generate_stage()
        solution = solver(stage)
        if len(solution) >= 8:
            hard_stage.append(stage)
            print("stage: ", stage.getArrayData())
            print("solution: ", solution)
            print("answerCount: ", len(solution))

def getAnswerCountDistribution():
    answerCount = [0 for i in range(20)]

    for i in range(10000000):
        stage = generate_stage()
        solution = solver(stage)
        # answerCount.append(len(solution))
        answerCount[len(solution)] += 1

    ratio_of_answer_count = [val / 1000000 for val in answerCount]
    print(answerCount)
    print(ratio_of_answer_count)
    # [456, 48466, 173208, 330935, 285782, 140076, 19703, 0, 1365, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0]
    # [0.000456, 0.048466, 0.173208, 0.330935, 0.285782, 0.140076, 0.019703, 0.0, 0.001365, 0.0, 0.0, 0.0, 9e-06, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
#     [4543, 484457, 1734855, 3310679, 2851643, 1402622, 197476, 0, 13647, 0, 0, 0, 78, 0, 0, 0, 0, 0, 0, 0]
# [0.004543, 0.484457, 1.734855, 3.310679, 2.851643, 1.402622, 0.197476, 0.0, 0.013647, 0.0, 0.0, 0.0, 7.8e-05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    #12개까지 답이 나올 수 있음
    # 7개, 9개, 10개, 11개는 없음


# make_hard_stage()
getAnswerCountDistribution()