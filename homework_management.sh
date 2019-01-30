#! /bin/bash

######################################################################
# 各个目录或文件路径
PATH_SAVE="./2_4"
PATH_ADMIN="$PATH_SAVE/Administrator"
PATH_TEACH="$PATH_SAVE/Teacher"
PATH_STU="$PATH_SAVE/Student"
PATH_RELEASE="$PATH_SAVE/Release"
PATH_REL_HW="$PATH_SAVE/Rel_HW"
PATH_HW="$PATH_SAVE/HW"

# 若没有这些目录或文件，则创建
if [ ! -d $PATH_SAVE ]
then
    mkdir $PATH_SAVE
fi

if [ ! -e $PATH_ADMIN ] 
then
    touch $PATH_ADMIN
fi

if [ ! -e $PATH_TEACH ] 
then
    touch $PATH_TEACH
fi

if [ ! -e $PATH_STU ] 
then
    touch $PATH_STU
fi

if [ ! -e $PATH_RELEASE ] 
then
    touch $PATH_RELEASE
fi

if [ ! -e $PATH_REL_HW ] 
then
    touch $PATH_REL_HW
fi

if [ ! -d $PATH_HW ]
then
    mkdir $PATH_HW
fi

######################################################################
# 用来记录三种账户登录的名称
PER_ADMIN=""
PER_TEACH=""
PER_STU=""

######################################################################

Admin_Login()
{
    # 若已经登录，就不必再次登录
    if [ ! -z $PER_ADMIN ]
    then
        echo "The Admin account $PER_ADMIN are already logged in."
        read -p "Press \`Enter\` to continue..." stop
        return 1
    fi

    # 判断储存管理员账户的文件是否为空
    A_LIST=`cat $PATH_ADMIN`
    # 仅判断前四位，若不为空，就视为有管理员账户
    if [ -z ${A_LIST:0:4} ]
    then
        echo "No Admin account yet!"
        read -p "Press \`Enter\` to continue..." stop
        clear
        return -1
    fi

    echo "Please input your Admin_ID:"
    echo -n "> "
    read A_ID
    echo ""

    echo "Please input password:"
    echo -n "> "
    read A_PASSWD
    echo ""

    # 在管理员账户文件中查找用户输入的ID是否存在
    tmp=`cat $PATH_ADMIN | grep "$A_ID"`
    tmp_A_PASSWD=`echo ${tmp#*" "}`

    # 若密码为空，表示前一步所存的结果为空，意味找不到
    if [ -z ${tmp_A_PASSWD:0:4} ]
    then
        echo "Login failed!"
        read -p "Press \`Enter\` to continue..." stop
        return 0
    # 密码一致，表示成功登录
    elif [ $tmp_A_PASSWD = $A_PASSWD ]
    then
        echo "Successfully login!"
        # 保存登录信息
        PER_ADMIN=$A_ID
        read -p "Press \`Enter\` to continue..." stop
        echo ""
        return 1
    else
        echo "Login failed!"
        read -p "Press \`Enter\` to continue..." stop
        return 0
    fi
}

Admin_Create()
{
    clear

    while true
    do
        echo "Please input Teacher_ID: "
        echo "Notice: The length of Teacher_ID must be 4."
        echo "        Input q to exit."
        echo -n "> "
        read T_ID
        echo ""

        if [ $T_ID = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi
        # 假定ID为4位
        if [ ${#T_ID} -ne 4 ]
        then
            echo "The length of Teacher_ID must be 4."
            echo "Please reenter."
            continue
        fi
        
        # 判断要新增的老师账户ID是否已经存在
        check=`cat $PATH_TEACH | grep $T_ID`
        if [ ! -z ${check:0:4} ]
        then
            echo "The ID: $T_ID is exist."
            echo "Please reenter."
            echo ""
            continue
        fi

        echo "Please input Teacher_Name:"
        echo "Notice: Input q to exit."
        echo -n "> "
        read T_Name
        echo ""

        if [ $T_Name = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi
        # 假定老师名称必须为4到16位
        if [ ${#T_Name} -lt 4 -o ${#T_Name} -gt 16 ]
        then
            echo "The length of Teacher_Name must be greater or eqaul to 4 and less or eqaul to 16."
            echo "Please reenter."
            continue
        fi

        # check=`cat $PATH_TEACH | grep $T_Name`
        # if [ -z $check ]
        # then
        #     echo "The ID: $T_Name is exist."
        #     echo "Please reenter."
        #     echo ""
        #    continue
        # fi

        while true
        do
            # 再次确认输入内容
            echo "ID: $T_ID"
            echo "Name: $T_Name"
            echo "Are you sure?"
            echo "Y or N."
            echo "Notice: Input q to exit."
            echo -n "> "
            read correctness
            echo ""

            if [ $correctness = "Y" ]
            then
                # 追加至老师账户文件
                echo "$T_ID ""$T_Name" >> $PATH_TEACH
                echo "Successfully create a Teacher account."
                read -p "Press \`Enter\` to continue..." stop
                return 1
            elif [ $correctness = "N" ]
            then
                # 若输入"N"，则重新输入
                echo "Please reenter from scratch."
                break
            elif [ $correctness = "q" ]
            then
                echo "Back to choose service."
                return 0
            else
                echo "Wrongly input."
                echo "Please reenter."
                continue
            fi
        done
    done
}

Admin_Modify()
{
    clear
    
    # 判断老师账户文件是否为空
    T_LIST=`cat $PATH_TEACH`
    # 仅判断老师ID
    if [ -z ${T_LIST:0:4} ]
    then
        echo "No Teacher account yet!"
        return 1
    fi

    echo "----------------------------------------"
    echo "|      Please choose how to modify     |"
    echo "|--------------------------------------|"
    echo "|      1 -    Input Teacher_ID         |"
    echo "|      2 -   Input Teacher_Name        |"
    echo "|      0 - Back to choose service      |"
    echo "----------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""
    
    case $CHOICE in
        "1")
            while true
            do
                echo "Please input which Teacher_ID you want to modify:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read T_Select
                echo ""

                if [ $T_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                # 判断要修改的老师账户ID是否存在，若不存在，则重新输入
                check=`cat $PATH_TEACH | grep $T_Select`
                if [ -z ${check:0:4} ]
                then 
                    echo "The ID: $T_Select is NOT found."
                    echo "Please reenter."
                    continue
                fi

                echo "Please input the new Teacher_ID:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read NEW_T_Select
                echo ""

                if [ $NEW_T_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                # 判断新的老师ID是否已经存在
                check=`cat $PATH_TEACH | grep $NEW_T_Select`
                if [ ! -z ${check:0:4} ]
                then 
                    echo "The New ID: $NEW_T_Select is exist."
                    echo "Please reenter."
                    continue
                fi

                while true
                do
                    # 再次确认
                    echo "Old Teacher_ID: $T_Select"
                    echo "New Teacher_ID: $NEW_T_Select"
                    echo ""
                    
                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 找到该老师账户信息
                        left=`cat $PATH_TEACH | grep $T_Select`
                        # 储存老师名称
                        left=${left#*" "}
                        # 找出该账户位于文件第几行，但因为输出有冒号，需要再提取
                        tmp=`cat $PATH_TEACH | grep -n $T_Select`
                        # 利用`awk`找出冒号位置
                        colon=`awk -v a="$tmp" -v b=":" 'BEGIN{print index(a,b)}'`
                        # 储存正确的行号
                        line=`echo $tmp | cut -c 1-$(($colon - 1))`
                        # 利用`sed`对文件进行修改
                        sed -i "${line}c$NEW_T_Select $left" $PATH_TEACH
                        echo "Successfully modify a Teacher account."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        echo ""
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        echo ""
                        continue
                    fi
                done
            done
            ;;
        "2")
            while true
            do
                echo "Please input which Teacher_Name you want to modify:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read T_Select
                echo ""

                if [ $T_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                # 判断要修改的老师账户名称是否存在，若不存在，则重新输入
                check=`cat $PATH_TEACH | grep $T_Select`
                if [ -z ${check:0:4} ]
                then 
                    echo "The Name: $T_Select is NOT found."
                    echo "Please reenter."
                    continue
                fi

                echo "Please input the new Teacher_Name:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read NEW_T_Select
                echo ""

                if [ $NEW_T_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                while true
                do
                    # 再次确认
                    echo "Old Teacher_Name: $T_Select"
                    echo "New Teacher_Name: $NEW_T_Select"
                    echo ""

                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 找到该老师账户信息
                        left=`cat $PATH_TEACH | grep $T_Select | cut -c 1-4`
                        # 找出该账户位于文件第几行，但因为输出有冒号，需要再提取
                        tmp=`cat $PATH_TEACH | grep -n $T_Select`
                        # 利用`awk`找出冒号位置
                        colon=`awk -v a="$tmp" -v b=":" 'BEGIN{print index(a,b)}'`
                        # 储存正确的行号
                        line=`echo $tmp | cut -c 1-$(($colon - 1))`
                        # 利用`sed`对文件进行修改
                        sed -i "${line}c$left $NEW_T_Select" $PATH_TEACH
                        echo "Successfully modify a Teacher account."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        echo ""
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            done
            ;;
        "0")
            echo "Back to choose service."
            return 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            Admin_Modify
    esac
}

Admin_Delete()
{
    clear

    # 判断老师账户文件是否为空
    T_LIST=`cat $PATH_TEACH`
    if [ -z ${T_LIST:0:4} ]
    then
        echo "No Teacher account yet!"
        return 1
    fi

    echo "----------------------------------------"
    echo "|      Please choose how to modify     |"
    echo "|--------------------------------------|"
    echo "|      1 -    Input Teacher_ID         |"
    echo "|      2 -   Input Teacher_Name        |"
    echo "|      0 - Back to choose service      |"
    echo "----------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    if [ $CHOICE = "0" ]
    then
        echo "Back to choose service."
        return 0
    fi

    while true
    do
        echo "Please input which Teacher_ID or Teacher_Name you want to delete:"
        echo "Notice: Input q to exit."
        echo -n "> "
        read T_Select
        echo ""

        if [ $T_Select = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi

        # 判断该老师ID是否存在
        check=`cat $PATH_TEACH | grep $T_Select`
        if [ -z ${check:0:4} ]
        then 
            echo "$T_Select is NOT found."
            echo "Please reenter."
            continue
        fi
        
        while true
        do
            if [ $CHOICE = "1" ]
            then
                echo "Teacher_ID you want to delete: $T_Select"
            else
                echo "Teacher_Name you want to delete: $T_Select"
            fi
            # 再次确认
            echo "Are you sure?"
            echo "Y or N."
            echo "Notice: Input q to exit."
            echo -n "> "
            read correctness
            echo ""

            if [ $correctness = "Y" ]
            then
                # 找到该老师账户信息
                left=`cat $PATH_TEACH | grep $T_Select | cut -c 1-4`
                # 找出该账户位于文件第几行，但因为输出有冒号，需要再提取
                tmp=`cat $PATH_TEACH | grep -n $T_Select`
                # 利用`awk`找出冒号位置
                colon=`awk -v a="$tmp" -v b=":" 'BEGIN{print index(a,b)}'`
                # 储存正确的行号
                line=`echo $tmp | cut -c 1-$(($colon - 1))`
                # 利用`sed`对文件进行修改
                sed -i "${line}d" $PATH_TEACH
                echo "Successfully delete a Teacher account."
                read -p "Press \`Enter\` to continue..." stop
                return 1
            elif [ $correctness = "N" ]
            then
                echo "Please reenter from scratch."
                break
            elif [ $correctness = "q" ]
            then
                echo "Back to choose service."
                return 0
            else
                echo "Wrongly input."
                echo "Please reenter."
                continue
            fi
        done
    done
}

Admin_Show()
{
    clear

    T_LIST=`cat $PATH_TEACH`
    if [ -z ${T_LIST:0:4} ]
    then
        echo "No Teacher account yet!"
        return 1
    fi

    echo "--------------------------------------------------"
    echo "|            Please choose how to show           |"
    echo "|------------------------------------------------|"
    echo "|    1 -   Input Teacher_ID & show its info      |"
    echo "|    2 - Input Teacher_Name & show its account   |"
    echo "|    3 -           Show all accounts             |"
    echo "|    0 -        Back to choose service           |"
    echo "--------------------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    case $CHOICE in
        "1")
            echo "Please input Teacher_ID you want to show:"
            echo "Notice: Input q to exit."
            echo -n "> "
            read T_ID
            echo ""

            if [ T_ID = "q" ]
            then
                return 0
            fi            
            # 判断该老师ID是否存在
            check=`cat $PATH_TEACH | grep "$T_ID"`
            if [ -z ${check:0:4} ]
            then
                echo "$T_ID is NOT found."
            else
                echo "ID   Name"
                echo "----------------------"
                echo "$check"
                echo "----------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "2")
            echo "Please input Teacher_Name you want to show:"
            echo "Notice: Input q to exit."
            echo -n "> "
            read T_Name
            echo ""

            if [ T_Name = "q" ]
            then
                return 0
            fi
            # 判断该老师名称是否存在
            check=`cat $PATH_TEACH | grep "$T_Name"`
            if [ -z ${check:0:4} ]
            then
                echo "$T_Name is NOT found."
            else
                echo "ID   Name"
                echo "----------------------"
                echo "$check"
                echo "----------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "3")
            # 判断老师账户文件是否为空
            check=`cat $PATH_TEACH`
            if [ -z ${check:0:4} ]
            then
                echo "NOT found."
            else
                echo "ID   Name"
                echo "----------------------"
                echo "$check"
                echo "----------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "0")
            echo "Back to choose service."
            return 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            Admin_Show
    esac
}

######################################################################

Teach_Login()
{
    # 若已经登录，就不必再次登录
    if [ ! -z $PER_TEACH ]
    then
        echo "The Admin account $PER_TEACH has been login."
        read -p "Press \`Enter\` to continue..." stop
        return 1
    fi

    # 判断储存老师账户的文件是否为空
    T_LIST=`cat $PATH_TEACH`
    # 仅判断前四位，若不为空，就视为有老师账户
    if [ -z ${T_LIST:0:4} ]
    then
        echo "No Teacher account yet!"
        return -1
    fi

    echo "Please input your Teacher_ID:"
    echo -n "> "
    read T_ID
    echo ""

    # 若在老师账户文件，找到该ID，则表示成功登录
    tmp=`cat $PATH_TEACH | grep "$T_ID"`
    if [ ! -z ${tmp:0:4} ]
    then
        echo "Successfully login!"
        PER_TEACH=$T_ID
        read -p "Press \`Enter\` to continue..." stop
        return 1
    else
        echo "Login failed!"
        read -p "Press \`Enter\` to continue..." stop
        return 0
    fi
}

Teach_Create()
{
    clear

    while true
    do
        echo "Please input Student_ID: "
        echo "Notice: The length of Student_ID must be 4."
        echo "        Input q to exit."
        echo -n "> "
        read S_ID
        echo ""

        if [ $S_ID = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi
        # 假定ID为4位
        if [ ${#S_ID} -ne 4 ]
        then
            echo "The length of Student_ID must be 4."
            echo "Please reenter."
            continue
        fi

        # 判断要新增的学生账户ID是否已经存在
        check=`cat $PATH_STU | grep $S_ID`
        if [ ! -z ${check:0:4} ]
        then
            echo "The ID: $S_ID is exist."
            echo "Please reenter."
            echo ""
            continue
        fi

        echo "Please input Student_Name:"
        echo "Notice: Input q to exit."
        echo -n "> "
        read S_Name
        echo ""

        if [ $S_Name = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi
        # 假定学生名称必须为4到16位
        if [ ${#S_Name} -lt 4 -o ${#S_Name} -gt 16 ]
        then
            echo "The length of Student_Name must be greater or eqaul to 4 and less or eqaul to 16."
            echo "Please reenter."
            continue
        fi

        # check=`cat $PATH_STU | grep $S_Name`
        # if [ -z $check ]
        # then
        #     echo "The ID: $S_Name is exist."
        #     echo "Please reenter."
        #     echo ""
        #     continue
        # fi

        while true
        do
            # 再次确认输入内容
            echo "ID: $S_ID"
            echo "Name: $S_Name"
            echo "Are you sure?"
            echo "Y or N."
            echo "Notice: Input q to exit."
            echo -n "> "
            read correctness
            echo ""

            if [ $correctness = "Y" ]
            then
                # 追加至学生账户文件
                echo "$S_ID ""$S_Name" >> $PATH_STU
                echo "Successfully create a Student account."
                read -p "Press \`Enter\` to continue..." stop
                return 1
            elif [ $correctness = "N" ]
            then
                echo "Please reenter from scratch."
                break
            elif [ $correctness = "q" ]
            then
                echo "Back to choose service."
                return 0
            else
                echo "Wrongly input."
                echo "Please reenter."
                continue
            fi
        done
    done
}

Teach_Modify()
{
    clear

    # 判断学生账户文件是否为空
    S_LIST=`cat $PATH_STU`
    if [ -z ${S_LIST:0:4} ]
    then
        echo "No Student account yet!"
        return 1
    fi

    echo "----------------------------------------"
    echo "|      Please choose how to modify     |"
    echo "|--------------------------------------|"
    echo "|      1 -    Input Student_ID         |"
    echo "|      2 -   Input Student_Name        |"
    echo "|      0 - Back to choose service      |"
    echo "----------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    case $CHOICE in
        "1")
            while true
            do
                echo "Please input which Student_ID you want to modify:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read S_Select
                echo ""

                if [ $S_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                # 判断要修改的学生账户ID是否存在，若不存在，则重新输入
                check=`cat $PATH_STU | grep $S_Select`
                if [ -z ${check:0:4} ]
                then 
                    echo "$S_Select is NOT found."
                    echo "Please reenter."
                    continue
                fi

                echo "Please input the new Student_ID:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read NEW_S_Select
                echo ""

                if [ $NEW_S_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                # 判断新的学生ID是否已经存在
                check=`cat $PATH_STU | grep $NEW_S_Select`
                if [ ! -z ${check:0:4} ]
                then 
                    echo "The New ID: $NEW_S_Select is exist."
                    echo "Please reenter."
                    continue
                fi

                while true
                do
                    # 再次确认
                    echo "Old Student_ID: $S_Select"
                    echo "New Student_ID: $NEW_S_Select"
                    echo ""
                    
                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 找到该学生账户信息
                        left=`cat $PATH_STU | grep $S_Select`
                        # 储存学生名称
                        left=${left#*" "}
                        # 找出该账户位于文件第几行，但因为输出有冒号，需要再提取
                        tmp=`cat $PATH_STU | grep -n $S_Select`
                        # 利用`awk`找出冒号位置
                        colon=`awk -v a="$tmp" -v b=":" 'BEGIN{print index(a,b)}'`
                        # 储存正确的行号
                        line=`echo $tmp | cut -c 1-$(($colon - 1))`
                        # 利用`sed`对文件进行修改
                        sed -i "${line}c$NEW_S_Select $left" $PATH_STU
                        echo "Successfully modify a Student account."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        echo ""
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        echo ""
                        continue
                    fi
                done
            done
            ;;
        "2")
            while true
            do
                echo "Please input which Student_Name you want to modify:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read S_Select
                echo ""

                if [ $S_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                # 判断要修改的学生账户名称是否存在，若不存在，则重新输入
                check=`cat $PATH_STU | grep $S_Select`
                if [ -z ${check:0:4} ]
                then 
                    echo "The Name: $S_Select is NOT found."
                    echo "Please reenter."
                    echo ""
                    continue
                fi

                echo "Please input the new Student_Name:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read NEW_S_Select
                echo ""

                if [ $NEW_S_Select = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                while true
                do
                    # 再次确认
                    echo "Old Student_Name: $S_Select"
                    echo "New Student_Name: $NEW_S_Select"
                    echo ""

                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 找到该学生账户信息
                        left=`cat $PATH_STU | grep $S_Select | cut -c 1-4`
                        # 找出该账户位于文件第几行，但因为输出有冒号，需要再提取
                        tmp=`cat $PATH_STU | grep -n $S_Select`
                        # 利用`awk`找出冒号位置
                        colon=`awk -v a="$tmp" -v b=":" 'BEGIN{print index(a,b)}'`
                        # 储存正确的行号
                        line=`echo $tmp | cut -c 1-$(($colon - 1))`
                        # 利用`sed`对文件进行修改
                        sed -i "${line}c$left $NEW_S_Select" $PATH_STU
                        echo "Successfully modify a Student account."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        echo ""
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            done
            ;;
        "0")
            echo "Back to choose service."
            return 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            Admin_Modify
    esac
}

Teach_Delete()
{
    clear

    # 判断学生账户文件是否为空
    S_LIST=`cat $PATH_STU`
    if [ -z ${S_LIST:0:4} ]
    then
        echo "No Student account yet!"
        return 1
    fi

    echo "----------------------------------------"
    echo "|      Please choose how to modify     |"
    echo "|--------------------------------------|"
    echo "|      1 -    Input Student_ID         |"
    echo "|      2 -   Input Student_Name        |"
    echo "|      0 - Back to choose service      |"
    echo "----------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    if [ $CHOICE = "0" ]
    then
        echo "Back to choose service."
        return 0
    fi

    while true
    do
        echo "Please input which Student_ID or Student_Name you want to delete:"
        echo "Notice: Input q to exit."
        echo -n "> "
        read S_Select
        echo ""

        if [ $S_Select = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi

        # 判断该学生ID是否存在
        check=`cat $PATH_STU | grep $S_Select`
        if [ -z ${check:0:4} ]
        then 
            echo "$S_Select is NOT found."
            echo "Please reenter."
            continue
        fi
        
        while true
        do
            if [ $CHOICE = "1" ]
            then
                echo "Student_ID you want to delete: $S_Select"
            else
                echo "Student_Name you want to delete: $S_Select"
            fi
            # 再次确认
            echo "Are you sure?"
            echo "Y or N."
            echo "Notice: Input q to exit."
            echo -n "> "
            read correctness
            echo ""

            if [ $correctness = "Y" ]
            then
                # 找到该学生账户信息
                left=`cat $PATH_STU | grep $S_Select | cut -c 1-4`
                # 找出该账户位于文件第几行，但因为输出有冒号，需要再提取
                tmp=`cat $PATH_STU | grep -n $S_Select`
                # 利用`awk`找出冒号位置
                colon=`awk -v a="$tmp" -v b=":" 'BEGIN{print index(a,b)}'`
                # 储存正确的行号
                line=`echo $tmp | cut -c 1-$(($colon - 1))`
                # 利用`sed`对文件进行修改
                sed -i "${line}d" $PATH_STU
                echo "Successfully delete a Student account."
                read -p "Press \`Enter\` to continue..." stop
                return 1
            elif [ $correctness = "N" ]
            then
                echo "Please reenter from scratch."
                break
            elif [ $correctness = "q" ]
            then
                echo "Back to choose service."
                return 0
            else
                echo "Wrongly input."
                echo "Please reenter."
                continue
            fi
        done
    done
}

Teach_Import()
{
    clear

    while true
    do
        echo "Please input which file you want to import:"
        echo "Notice: Input q to exit."
        echo -n "> "
        read FILE 
        echo ""

        if [ $FILE = "q" ]
        then
            echo "Back to choose service."
            return 0
        fi

        while true
        do
            # 再次确认
            echo "The imported file is: $FILE"
            cat $FILE
            echo ""
            echo "Are you sure?"
            echo "Y or N."
            echo "Notice: Input q to exit."
            echo -n "> "
            read correctness
            echo ""

            if [ $correctness = "Y" ]
            then
                # 追加至学生账户文件
                cat $FILE >> $PATH_STU
                echo "Successfully import the file to Student Info."
                read -p "Press \`Enter\` to continue..." stop
                return 1
            elif [ $correctness = "N" ]
            then
                echo "Please reenter from scratch."
                break
            elif [ $correctness = "q" ]
            then
                echo "Back to choose service."
                return 0
            else
                echo "Wrongly input."
                echo "Please reenter."
                continue
            fi
        done
    done
}

Teach_Show()
{
    clear

    # 判断学生账户文件是否为空
    S_LIST=`cat $PATH_STU`
    if [ -z ${S_LIST:0:4} ]
    then
        echo "No Student account yet!"
        return 1
    fi

    echo "--------------------------------------------------"
    echo "|            Please choose how to show           |"
    echo "|------------------------------------------------|"
    echo "|    1 -   Input Student_ID & show its info      |"
    echo "|    2 - Input Student_Name & show its account   |"
    echo "|    3 -           Show all accounts             |"
    echo "|    0 -        Back to choose service           |"
    echo "--------------------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    case $CHOICE in
        "1")
            echo "Please input Student_ID you want to show:"
            echo "Notice: Input q to exit."
            echo -n "> "
            read S_ID
            echo ""

            if [ S_ID = "q" ]
            then
                return 0
            fi
            # 判断该学生ID是否存在
            check=`cat $PATH_STU | grep "$S_ID"`
            if [ -z ${check:0:4} ]
            then
                echo "$S_ID is NOT found."
            else
                echo "ID   Name"
                echo "----------------------"
                echo "$check"
                echo "----------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "2")
            echo "Please input Student_Name you want to show:"
            echo "Notice: Input q to exit."
            echo -n "> "
            read S_Name
            echo ""

            if [ S_Name = "q" ]
            then
                return 0
            fi
            # 判断该学生名称是否存在
            check=`cat $PATH_STU | grep "$S_Name"`
            if [ -z ${check:0:4} ]
            then
                echo "$S_Name is NOT found."
            else
                echo "ID   Name"
                echo "----------------------"
                echo "$check"
                echo "----------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "3")
            # 判断该学生账户文件是否为空
            check=`cat $PATH_STU`
            if [ -z ${check:0:4} ]
            then
                echo "NOT found."
            else
                echo "ID   Name"
                echo "----------------------"
                echo "$check"
                echo "----------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "0")
            echo "Back to choose service."
            return 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            Teach_Show
    esac
}

Teach_Release()
{
    clear

    echo "--------------------------------------------------"
    echo "|     Please choose what to do to Course Info    |"
    echo "|------------------------------------------------|"
    echo "|           1 - Release new Course Info          |"
    echo "|           2 -    Edit Course Info              |"
    echo "|           3 -   Delete Course Info             |"
    echo "|           4 -    Show Course Infos             |"
    echo "|           0 - Back to choose service           |"
    echo "--------------------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    case $CHOICE in
        "1")
            while true
            do 
                echo "Please input the new Course Info:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read INFO
                echo ""

                if  [ ${INFO:0:1} = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                while true
                do
                    # 再次确认
                    echo "The new Info is: "
                    echo "$INFO"
                    echo ""

                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 计算行数
                        line=`cat $PATH_RELEASE | wc -l`
                        # 从下一行新增
                        echo "$(($line + 1)) $INFO" >> $PATH_RELEASE
                        echo "Successfully release a new Course Info."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            done 
            ;;
        "2")
            C_LIST=`cat $PATH_RELEASE`
            if [ -z ${C_LIST:0:1} ]
            then
                echo "No Course Info yet!"
                return 1
            fi

            while true
            do
                echo "--------------------------------------------------"
                cat $PATH_RELEASE
                echo "--------------------------------------------------"
                echo ""
                echo "Please input which Course Info you want to edit:"
                echo "Notice: Input q to exit."
                echo "        Please input the number of the Course Info."
                echo -n "> "
                read NO 
                echo ""

                if [ $NO = "q" ]
                then 
                    echo "Back to choose service."
                    return 0
                fi
                
                echo "Please input the new Course Info:"
                echo -n "> "
                read CONTENT
                echo ""

                while true
                do  
                    echo "--------------------------------------------------"
                    # 利用`head`和`tail`截取该行
                    cat $PATH_RELEASE | head -n $NO | tail -n 1
                    echo "--------------------------------------------------"
                    echo ""
                    echo "will become"
                    echo ""
                    echo "--------------------------------------------------"
                    echo "$NO $CONTENT"
                    echo "--------------------------------------------------"
                    echo ""
                    # 再次确认
                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 利用`sed`编辑该课程信息
                        sed -i "${NO}c${NO} $CONTENT" $PATH_RELEASE
                        echo "Successfully edit the Course Info."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            done
            ;;
        "3")
            C_LIST=`cat $PATH_RELEASE`
            if [ -z ${C_LIST:0:1} ]
            then
                echo "No Course Info yet!"
                return 1
            fi

            while true
            do
                echo "--------------------------------------------------"
                cat $PATH_RELEASE
                echo "--------------------------------------------------"
                echo ""
                echo "Please input which Course Info you want to delete:"
                echo "Notice: Input q to exit."
                echo "        Please input the number of the Course Info."
                echo -n "> "
                read NO 
                echo ""

                if [ $NO = "q" ]
                then 
                    echo "Back to choose service."
                    return 0
                fi

                while true
                do
                    echo "--------------------------------------------------"
                    # 利用`head`和`tail`截取该行
                    cat $PATH_RELEASE | head -n $NO | tail -n 1
                    echo "--------------------------------------------------"
                    echo ""
                    echo "will be deleted."

                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 计算课程信息行数
                        line=`cat $PATH_RELEASE | wc -l`
                        if [ $line -ge $NO ]
                        then
                            tmp_NO=$(($NO + 1))
                            # 把被删除的课程信息之后的所有课程信息的编号都往前挪一位
                            for((i=$tmp_NO; i<=$line; i++))
                            do
                                tmp=`cat $PATH_RELEASE | head -n $i | tail -n 1`
                                len=${#tmp}
                                left=${tmp:2:$(($len - 2))}
                                # 利用`sed`修改文件
                                sed -i "${i}c$(($i - 1)) $left" $PATH_RELEASE
                            done
                        fi
                        
                        # 利用`sed`删除该行
                        sed -i "${NO}d" $PATH_RELEASE
                        echo "Successfully delete the Course Info."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done 
            done
            ;;
        "4")
            # 判断课程信息文件是否为空
            C_LIST=`cat $PATH_RELEASE`
            if [ -z ${C_LIST:0:1} ]
            then
                echo "No Course Info yet!"
                return 1
            fi

            # echo "NoCourse Info"
            echo "--------------------------------------------------"
            cat $PATH_RELEASE
            echo "--------------------------------------------------"
            echo ""
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "0")
            echo "Back to choose service."
            return 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            Teach_Release
    esac
}

Teach_Give()
{
    clear

    echo "------------------------------------------------------------"
    echo "|          Please choose what to do to Assignment          |"
    echo "------------------------------------------------------------"
    echo "|   1 -              Release new Assignment                |"
    echo "|   2 -                  Edit Assignment                   |"
    echo "|   3 -                 Delete Assignment                  |"
    echo "|   4 -                 Show Assignments                   |"
    echo "|   5 - Search the Completion of Assignment of a Student   |"
    echo "|   6 - Show the Completion of Assignment of whole class   |"
    echo "|   0 -              Back to choose service                |"
    echo "------------------------------------------------------------"
    echo -n "> "
    read CHOICE
    echo ""

    case $CHOICE in
        "1")
            while true
            do 
                echo "Please input the new Assignment:"
                echo "Notice: Input q to exit."
                echo -n "> "
                read HW
                echo ""

                if  [ $HW = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                fi

                while true
                do
                    echo "The new Assignment is: "
                    echo "$HW"
                    echo ""
                    # 再次确认
                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 计算行数
                        line=`cat $PATH_REL_HW | wc -l`
                        # 从下一行追加
                        echo "$(($line + 1)) $HW" >> $PATH_REL_HW
                        echo "Successfully release a new assignment."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            done 
            ;;
        "2")
            while true
            do
                echo "--------------------------------------------------"
                cat $PATH_REL_HW
                echo "--------------------------------------------------"
                echo ""
                echo "Please input which Assignment you want to edit:"
                echo "Notice: Input q to exit."
                echo "        Please input the number of the Assignment."
                echo -n "> "
                read NO 
                echo ""

                if [ $NO = "q" ]
                then 
                    echo "Back to choose service."
                    return 0
                fi
                # 截取前两位，判断该编号是否存在（假定编号不会超过99位）
                check=`cat $PATH_REL_HW | cut -c 1-2 | grep $NO`
                # 需添加一个空格一起找，若不加空格像是"1 "和"11"可能同时被找到
                if [ -z ${check:0:1}" " ]
                then
                    echo "$NO is NOT found."
                    echo "Please reenter."
                    continue
                fi
                
                echo "Please input the new Assignment:"
                echo -n "> "
                read CONTENT
                echo ""

                while true
                do  
                    echo "--------------------------------------------------"
                    # 利用`head`和`tail`截取信息
                    cat $PATH_REL_HW | head -n $NO | tail -n 1
                    echo "--------------------------------------------------"
                    echo ""
                    echo "will become"
                    echo ""
                    echo "--------------------------------------------------"
                    echo "$NO $CONTENT"
                    echo "--------------------------------------------------"
                    echo ""
                    # 再次确认
                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 利用`sed`编辑作业
                        sed -i "${NO}c${NO} $CONTENT" $PATH_REL_HW
                        echo "Successfully edit the Assignment."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            done
            ;;
        "3")
            while true
            do
                echo "--------------------------------------------------"
                cat $PATH_REL_HW
                echo "--------------------------------------------------"
                echo ""
                echo "Please input which Assignment you want to delete:"
                echo "Notice: Input q to exit."
                echo "        Please input the number of the Assignment."
                echo -n "> "
                read NO 
                echo ""

                if [ $NO = "q" ]
                then 
                    echo "Back to choose service."
                    return 0
                fi
                # 截取前两位，判断该编号是否存在（假定编号不会超过99位）
                check=`cat $PATH_REL_HW | cut -c 1-2 | grep $NO`
                # 需添加一个空格一起找，若不加空格像是"1 "和"11"可能同时被找到
                if [ -z ${check:0:1}" " ]
                then
                    echo "$NO is NOT found."
                    echo "Please reenter."
                    continue
                fi

                while true
                do
                    echo "--------------------------------------------------"
                    cat $PATH_REL_HW | head -n $NO | tail -n 1
                    echo "--------------------------------------------------"
                    echo ""
                    echo "will be deleted."
                    echo ""

                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 计算行数
                        line=`cat $PATH_REL_HW | wc -l`
                        if [ $line -ge $NO ]
                        then
                            tmp_NO=$(($NO + 1))
                            # 把被删除的作业之后的所有作业的编号都往前挪一位
                            for((i=$tmp_NO; i<=$line; i++))
                            do
                                tmp=`cat $PATH_REL_HW | head -n $i | tail -n 1`
                                len=${#tmp}
                                left=${tmp:2:$(($len - 2))}
                                # 利用`sed`修改文件
                                sed -i "${i}c$(($i - 1)) $left" $PATH_REL_HW
                            done
                        fi
                        
                        # 利用`sed`删除该行
                        sed -i "${NO}d" $PATH_REL_HW
                        echo "Successfully delete the Assignment."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done 
            done
            ;;
        "4")
            # 判断作业文件是否为空
            check=`cat $PATH_REL_HW`
            if [ -z ${check:0:1} ]
            then
                echo "NOT found."
            else
                echo "--------------------------------------------------"
                echo "$check"
                echo "--------------------------------------------------"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "5")
            echo "Please input the Student_ID or Student_Name you want to search:"
            echo "Notice: Input q to exit."
            echo -n "> "
            read S_NameID
            echo ""

            if [ $S_NameID = "q" ]
            then 
                echo "Back to choose service."
                return 0
            fi
            # 查找该学生是否有文件存在文件夹$PATH_HW下
            tmp=`ls $PATH_HW | grep $S_NameID`

            if [ -z ${tmp:0:4} ]
            then
                echo "The Student has NOT submitted his/her HW."
            else
                len=${#tmp}
                # 截取前四位，表示ID
                S_ID=${tmp:0:4}
                # 截取之后字符串，但要避开下划线，表示名称
                S_Name=${tmp:5:$(($len - 5))}

                echo "The Student '$S_Name'(ID: $S_ID) has submitted his/her HW, "
                echo "and the filename is \`$tmp\`"
            fi
            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "6")
            echo "--------------------------------------------------"
            echo "Notice: (O) Submitted"
            echo "        (X) Unsubmitted"
            echo "        (*) Filename Error"
            echo "--------------------------------------------------"
            
            # 找出该账户位于文件第几行，但因为输出有空格，需要再提取
            tmp=`wc -l $PATH_STU`
            # 记录空格位置
            space=`awk -v a="$tmp" -v b=" " 'BEGIN{print index(a,b)}'`
            # 记录学生账户数目
            TOT_NO=`echo $tmp | cut -c 1-$(($space - 1))`
            # 记录在文件夹$PATH_HW下所有文件数目
            NO=`ls $PATH_HW | wc -l`

            declare -i flag=0
            declare -i NUM=0

            for((i=1; i<=$TOT_NO; i++))
            do
                flag=0
                tmp=`cat $PATH_STU | head -n $i | tail -n 1`
                # echo "tmp = $tmp"
                len=${#tmp}
                S_ID=${tmp:0:4}
                S_Name=${tmp:5:$(($len - 5))}
                # 所有文件
                FILES=$PATH_HW"/*"
                # 文件夹$PATH_HW名称的长度
                LEN_PATH=$((${#PATH_HW} + 1))
                # 遍历所有在文件夹$PATH_HW下的文件
                for file in $FILES
                do  
                    # echo "file = $file"
                    # 因为$file是在当前文件夹下的路径如"./2_4/HW/0001_xzj123"，仅需保存学生ID和学生名称
                    tmp_len=${#file}
                    tmp_ID=${file:$LEN_PATH:4}
                    tmp_Name=${file:$(($LEN_PATH + 5)):$(($tmp_len - $LEN_PATH - 5))}
                    # echo "id = $tmp_ID"
                    # echo "name = $tmp_Name"
                    # echo ""

                    # 若ID和名称都对应，表示该名学生已经提交作业
                    if [ $tmp_ID = $S_ID -a $tmp_Name = $S_Name ]
                    then
                        echo "(O) $S_Name(ID: $S_ID)"
                        NUM=$(($NUM + 1))
                        break
                    # 若ID或名称仅有其中一项没有对应，表示该文件名称出错
                    elif [ $tmp_ID = $S_ID -a $tmp_Name != $S_Name -o $tmp_ID != $S_ID -a $tmp_Name = $S_Name ]
                    then
                        echo "(*) $S_Name(ID: $S_ID)"
                        break
                    else
                        # 若经过和$PATH_HW下文件数相同多次的遍历，仍没匹配，表示该学生没有提交作业
                        flag=$(($flag + 1))

                        if [ $flag -eq $NO ]
                        then
                            echo "(X) $S_Name(ID: $S_ID)"
                        fi
                    fi
                done   
            done   

            # echo $NUM
            echo "--------------------------------------------------"
            # 利用百分比，显示提交率
            rate=`echo "scale=2; $NUM * 100 / $TOT_NO" | bc`
            echo "Submitted rate: ${rate}%"
            echo "--------------------------------------------------"
            echo ""

            read -p "Press \`Enter\` to continue..." stop
            return 1
            ;;
        "0")
            echo "Back to choose service."
            return 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            Teach_Give
    esac
}

######################################################################

Stu_Login()
{
    # 若已经登录，就不必再次登录
    if [ ! -z $PER_STU ]
    then
        echo "The Admin account $PER_STU has been login."
        read -p "Press \`Enter\` to continue..." stop
        return 1
    fi

    # 判断储存学生账户的文件是否为空
    S_LIST=`cat $PATH_STU`
    # 仅判断前四位，若不为空，就视为有学生账户
    if [ -z ${S_LIST:0:4} ]
    then
        echo "No Student account yet!"
        return -1
    fi

    echo "Please input your Student_ID:"
    echo -n "> "
    read S_ID
    echo ""

    # 在学生账户文件中查找用户输入的ID是否存在
    tmp=`cat $PATH_STU | grep "$S_ID"`
    if [ ! -z ${tmp:0:4} ]
    then
        echo "Successfully login!"
        PER_STU=$S_ID
        read -p "Press \`Enter\` to continue..." stop
        return 1
    else
        echo "Login failed!"
        read -p "Press \`Enter\` to continue..." stop
        return 0
    fi
}

Stu_Create()
{
    clear
    while true
    do
        echo "Please input the filename you want to create:"
        echo "Notice: Extension is also needed."
        echo "        The system wil create the file and open with \`vim\` for you."
        echo "        Input q to exit."
        echo -n "> "
        read filename

        if [ $filename = "q" ]
        then 
            echo "Back to choose service."
            return 0
        fi

        # 文件夹$PATH_HW名称的长度
        FILENAME=$PATH_HW"/"$filename
        while true
        do
            # 判断该文件是否存在
            if [ -e $FILENAME ]
            then
                echo "--------------------------------------------------"
                echo "Warning: The file $filename is already exist."
                echo "         The system will open the file with \`vim\` for you."
                echo "--------------------------------------------------"
                echo ""
                read -p "Press \`Enter\` to continue..." stop

                # 帮用户用`vim`打开文件
                vim $FILENAME
                clear
                echo "Successfully close $filename."
                read -p "Press \`Enter\` to continue..." stop
            else
                echo "File \`$filename\` will be created."
                echo ""
                # 再次确认
                echo "Are you sure?"
                echo "Y or N."
                echo "Notice: Input q to exit."
                echo -n "> "
                read correctness
                echo ""

                if [ $correctness = "Y" ]
                then
                    # 生成文件
                    touch $FILENAME
                    echo "Successfully create $filename."
                    read -p "Press \`Enter\` to continue..." stop

                    # 帮用户用`vim`打开文件
                    vim $FILENAME
                    clear
                    echo "Successfully close $filename."
                    read -p "Press \`Enter\` to continue..." stop          
                    return 1
                elif [ $correctness = "N" ]
                then
                    echo "Please reenter from scratch."
                    break
                elif [ $correctness = "q" ]
                then
                    echo "Back to choose service."
                    return 0
                else
                    echo "Wrongly input."
                    echo "Please reenter."
                    continue
                fi
            fi
        done
    done
}

Stu_Edit()
{
    clear

    while true
    do
        echo "Please input the filename you want to edit:"
        echo "Notice: Extension is also needed."
        echo "        The system wil open the file with \`vim\` for you."
        echo "        Input q to exit."
        echo -n "> "
        read filename

        if [ $filename = "q" ]
        then 
            echo "Back to choose service."
            return 0
        fi

        tmp=${filename:0:4}
        
        # left=`expr index $filename "."`
        # if [ $left -ne 0 ]
        # then
        #     tmp=${filename:0:$(($left - 1))}
        # else
        #     tmp=$filename
        # fi
        
        # 必须与登录的学生账户ID相同才能编辑文件
        if [ $PER_STU != $tmp ]
        then
            echo "--------------------------------------------------"
            echo "You are NOT permitted to edit $filename."
            echo "--------------------------------------------------"

            echo "Please reenter the filename you want to edit."
            continue
        else
            FILENAME=$PATH_HW"/"$filename
            if [ ! -e $FILENAME ]
            then
                while true
                do
                    echo "File \`$filename\` will be created."
                    echo ""
                    echo "Are you sure?"
                    echo "Y or N."
                    echo "Notice: Input q to exit."
                    echo -n "> "
                    read correctness
                    echo ""

                    if [ $correctness = "Y" ]
                    then
                        # 生成文件
                        touch $FILENAME
                        echo "Successfully create $filename."
                        read -p "Press \`Enter\` to continue..." stop
                        
                        # 帮用户用`vim`打开文件
                        vim $FILENAME
                        echo "Successfully close $filename."
                        read -p "Press \`Enter\` to continue..." stop
                        return 1         
                    elif [ $correctness = "N" ]
                    then
                        echo "Please reenter from scratch."
                        break
                    elif [ $correctness = "q" ]
                    then
                        echo "Back to choose service."
                        return 0
                    else
                        echo "Wrongly input."
                        echo "Please reenter."
                        continue
                    fi
                done
            else
                read -p "Press \`Enter\` to continue..." stop

                vim $filename
                clear
                echo "Successfully close $filename."
                return 1
            fi
        fi
    done
}

Stu_Search()
{
    clear

    while true
    do
        echo "Please input the filename you want to search:"
        echo "Notice: Extension is also needed."
        echo "        The system wil show the contents of the file for you."
        echo "        Input q to exit."
        echo -n "> "
        read filename

        if [ $filename = "q" ]
        then 
            echo "Back to choose service."
            return 0
        fi

        tmp=${filename:0:4}

        # 必须与登录的学生账户ID相同才能查找文件
        if [ $PER_STU != $tmp ]
        then
            echo "You are NOT permitted to edit $filename."
            echo "Please reenter."
            echo ""
            continue
        else
            FILENAME=$PATH_HW"/"$filename
            echo "Notice: Enter \`q\` to exit."
            read -p "Press \`Enter\` to continue..." stop
            # 利用`less`显示该文件内容，相较`cat`能够上下移动，阅读文件
            less -m $FILENAME
            clear
            echo "Successfully close $filename."
            read -p "Press \`Enter\` to continue..." stop
            return 1
        fi
    done
}

######################################################################

Administrator()
{
    Admin_Login
    if [ $? -ne 1 ]
    then
        return -1
    fi

    while true
    do
        clear

        echo "----------------------------------------"
        echo "|         Please choose service        |"
        echo "|--------------------------------------|"
        echo "|      1 - Create Teacher account      |"
        echo "|      2 - Modify Teacher account      |"
        echo "|      3 - Delete Teacher account      |"
        echo "|      4 - Show Teacher accounts       |"
        echo "|      0 -      Back to Menu           |"
        echo "----------------------------------------"
        echo "Notice: <Ctrl + C> to Force-Quit."
        echo -n "> "
        read A_SERVICE
        echo ""

        case $A_SERVICE in
            "1")
                echo "Service: 1 - Create Teacher account"
                Admin_Create
                ;;
            "2")
                echo "Service: 2 - Modify Teacher account"
                Admin_Modify
                ;;
            "3")
                echo "Service: 3 - Delete Teacher account"
                Admin_Delete
                ;;
            "4")
                echo "Service: 4 - Show Teacher accounts"
                Admin_Show
                ;;
            "0")
                echo "Back to Menu."
                echo ""
                return 0
                ;;
            *) 
                echo "Wrongly input."
                echo "Please reenter."
                continue
                ;;
        esac
    done
}

######################################################################

Teacher()
{
    Teach_Login
    if [ $? -ne 1 ]
    then
        return -1
    fi

    while true
    do
        clear
        
        echo "--------------------------------------------------"
        echo "|              Please choose service             |"
        echo "|------------------------------------------------|"
        echo "|           1 - Create Student account           |"
        echo "|           2 - Modify Student account           |"
        echo "|           3 - Delete Student account           |"
        echo "|           4 - Import Student account           |"
        echo "|           5 -  Show Student acoounts           |"
        echo "|           6 -   Release Course Info            |"
        echo "|           7 -    Give assignments              |"
        echo "|           0 -      Back to Menu                |"
        echo "--------------------------------------------------"
        echo "Notice: <Ctrl + C> to Force-Quit."
        echo -n "> "
        read T_SERVICE
        echo ""

        case $T_SERVICE in
            "1")
                echo "Service 1 - Create Student account"
                Teach_Create
                ;;
            "2")
                echo "Service 2 - Modify Student account"
                Teach_Modify
                ;;
            "3")
                echo "Service 3 - Delete Student account"
                Teach_Delete
                ;;
            "4")
                echo "Service 4 - Import Student account"
                Teach_Import
                ;;
            "5")
                echo "Service 5 - Show Student accounts"
                Teach_Show
                ;;
            "6")
                echo "Service 6 - Release Course Info"
                Teach_Release
                ;;
            "7")
                echo "Service 7 - Give assignments or Experiments"
                Teach_Give
                ;;
            "0")
                echo "Back to Menu"
                echo ""
                return 0
                ;;
            *) 
                echo "Wrongly input."
                echo "Please reenter."
                continue
                ;;
        esac
    done
}

######################################################################

Student()
{
    Stu_Login
    if [ $? -ne 1 ]
    then
        return -1
    fi

    while true
    do
        clear

        echo "----------------------------------------"
        echo "|         Please choose service        |"
        echo "|--------------------------------------|"
        echo "|      1 - Create your Assignment      |"
        echo "|      2 -  Edit your Assignment       |"
        echo "|      3 - Search your Assignments     |"
        echo "|      0 -      Back to Menu           |"
        echo "----------------------------------------"
        echo "Notice: <Ctrl + C> to Force-Quit."
        echo -n "> "
        read S_SERVICE
        echo ""

        case $S_SERVICE in
            "1")
                echo "Service 1 - Create your Assignment"
                Stu_Create
                ;;
            "2")
                echo "Service 2 - Edit your Assignment"
                Stu_Edit
                ;;
            "3")
                echo "Service 3 - Search your Assignments"
                Stu_Search
                ;;
            "0")
                echo "Back to Menu"
                echo ""
                return 0
                ;;
            *) 
                echo "Wrongly input."
                echo "Please reenter."
                continue
                ;;
        esac
    done
}

######################################################################

while true
do
    clear

    echo "----------------------------------------------------"
    echo "|  Please input the type of user you want to login |"
    echo "|--------------------------------------------------|"
    echo "|                 1 - Administrator                |"
    echo "|                 2 -    Teacher                   |"
    echo "|                 3 -    Student                   |"
    echo "|                 0 -     Exit                     |"
    echo "----------------------------------------------------"
    echo "Notice: <Ctrl + C> to Force-Quit."
    echo -n "> "
    read USER_TYPE
    echo ""

    case $USER_TYPE in
        "1") 
            echo "Type: Administrator"
            Administrator
            if [ $? -eq -1 ]
            then
                echo "Please reenter."
                continue
            fi
            ;;
        "2")
            echo "Type: Teacher"
            Teacher
            if [ $? -eq -1 ]
            then
                echo "Please reenter."
                continue
            fi
            ;;
        "3")
            echo "Type: Student"
            Student
            if [ $? -eq -1 ]
            then
                echo "Please reenter."
                continue
            fi
            ;;
        "0")
            echo "Exit. Bye."
            exit 0
            ;;
        *)
            echo "Wrongly input."
            echo "Please reenter."
            continue
    esac
done
