def age_calculator(birthday):
    import datetime
    from datetime import date
    birthdate = datetime.datetime(int(birthday[4:8]),int(birthday[2:4]),int(birthday[0:2]))
    today = date.today()
    Age = today.year - birthdate.year - ((today.month, today.day) < (birthdate.month, birthdate.day))
    print(Age)
    return Age

def calculate_tax_relief(salary,tax,gender,birthday):
    Age = age_calculator(birthday)
    print(Age)
    #gender_bonus
    if gender.upper() == "F":
        gender_bonus = 500.00
    else:
        gender_bonus = 0.00
    #Variable calculation
    if Age <= 18:
        variable = 1.00
    elif Age <= 35:
        variable = 0.80
    elif Age <= 50:
        variable = 0.50
    elif Age <= 75:
        variable = 0.367
    else:
        variable = 0.05
    print(Age)
    tax_relief =  "{:.2f}".format(((round(float(salary),0) - float(tax))*variable) + gender_bonus,2)
    print(tax_relief)
    if  float(tax_relief) >= 0.00 and float(tax_relief) <= 50.00:
        tax_relief = 50.00
        tax_relief =  "{:.2f}".format(tax_relief,2)
        print(tax_relief)
    return(tax_relief)

# generate mask national ID
def generate_mask_nationalid(Id):
    mask_id = Id[0:4]+ ("$"*(len(Id)-4))
    #print(mask_id)
    return (mask_id)


#Tax_Relief("600000.55","5500","M","29081971")
#mask_id("G1234567A")